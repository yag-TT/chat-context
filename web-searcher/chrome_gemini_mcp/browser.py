from __future__ import annotations

import asyncio
import time
from contextlib import asynccontextmanager
from typing import AsyncIterator
from urllib.parse import urlencode, urlparse

from playwright.async_api import Browser, BrowserContext, Page, Error as PlaywrightError, async_playwright

from chrome_gemini_mcp.config import Settings
from chrome_gemini_mcp.errors import (
    BrowserBlockedError,
    ChromeConnectionError,
    McpSearchError,
    PageInteractionError,
)
from chrome_gemini_mcp.models import FetchPageResponse, GeminiResponse, SearchResponse
from chrome_gemini_mcp.parsers import clean_text, extract_google_results, normalize_links


BLOCK_TEXT_MARKERS = (
    "unusual traffic from your computer network",
    "our systems have detected",
    "not a robot",
    "このネットワークから通常と異なるトラフィック",
    "ロボットではないことを確認",
    "before you continue to google",
    "google に移動する前に",
    "本人確認",
)


class ChromeGeminiClient:
    def __init__(self, settings: Settings):
        self.settings = settings

    @asynccontextmanager
    async def page(self) -> AsyncIterator[Page]:
        try:
            async with async_playwright() as playwright:
                browser = await playwright.chromium.connect_over_cdp(
                    self.settings.chrome_cdp_url,
                    timeout=self.settings.search_timeout_ms,
                )
                context = self._select_context(browser)
                page = await context.new_page()
                try:
                    yield page
                finally:
                    await page.close()
        except ChromeConnectionError:
            raise
        except Exception as exc:
            message = str(exc)
            if "connect" in message.lower() or "ecconnrefused" in message.lower():
                raise ChromeConnectionError(
                    "Chrome CDP is not reachable. Start the dedicated Chrome profile with "
                    "./scripts/start_chrome_cdp.sh and verify http://127.0.0.1:9222/json/version."
                ) from exc
            raise

    def _select_context(self, browser: Browser) -> BrowserContext:
        if not browser.contexts:
            raise ChromeConnectionError("Connected to Chrome, but no browser context was available.")
        return browser.contexts[0]

    async def google_search(
        self,
        query: str,
        max_results: int = 5,
        language: str = "ja",
        region: str = "JP",
    ) -> SearchResponse:
        started = time.monotonic()
        max_results = max(1, min(max_results, 20))
        params = {
            "q": query,
            "hl": language,
            "gl": region,
            "num": str(max_results),
            "pws": "0",
        }
        search_url = f"{self.settings.google_search_base_url}?{urlencode(params)}"

        async with self.page() as page:
            await page.goto(search_url, wait_until="domcontentloaded", timeout=self.settings.search_timeout_ms)
            await self._raise_if_blocked(page)
            await page.wait_for_timeout(1000)
            html = await page.content()
            results = extract_google_results(html, max_results)

        return SearchResponse(
            query=query,
            source="google_search_page",
            results=results,
            elapsed_ms=_elapsed_ms(started),
        )

    async def fetch_page(self, url: str, max_chars: int = 6000) -> FetchPageResponse:
        started = time.monotonic()
        parsed = urlparse(url)
        if parsed.scheme not in {"http", "https"}:
            raise PageInteractionError("fetch_page only accepts http and https URLs.")
        max_chars = max(500, min(max_chars, 50_000))

        async with self.page() as page:
            await page.goto(url, wait_until="domcontentloaded", timeout=self.settings.search_timeout_ms)
            await page.wait_for_timeout(1000)
            title = clean_text(await page.title())
            text = await page.evaluate("() => document.body ? document.body.innerText : ''")
            text = clean_text(text)

        truncated = len(text) > max_chars
        return FetchPageResponse(
            url=url,
            title=title,
            text=text[:max_chars],
            truncated=truncated,
            elapsed_ms=_elapsed_ms(started),
        )

    async def gemini_web_search(self, query: str, timeout_sec: int = 90) -> GeminiResponse:
        started = time.monotonic()
        timeout_ms = max(10_000, min(timeout_sec * 1000, 180_000))
        prompt = (
            "Web検索を使って最新情報を確認し、根拠URLを含めて日本語で簡潔に回答してください。\n"
            "推測と確認済み事実を区別してください。\n\n"
            f"質問: {query}"
        )

        async with self.page() as page:
            page.set_default_timeout(timeout_ms)
            await page.goto(self.settings.gemini_url, wait_until="domcontentloaded", timeout=timeout_ms)
            await page.wait_for_timeout(1500)
            await self._raise_if_blocked(page)
            await self._try_start_new_gemini_chat(page)

            before = await self._gemini_response_candidates(page)
            input_box = await self._find_gemini_input(page)
            await input_box.click()
            await input_box.fill(prompt)
            await self._submit_gemini_prompt(page)

            answer_markdown = await self._wait_for_gemini_answer(page, before, timeout_ms)
            references = await self._gemini_response_links(page, answer_markdown)

        return GeminiResponse(
            query=query,
            answer_markdown=answer_markdown,
            references=references,
            elapsed_ms=_elapsed_ms(started),
        )

    async def _raise_if_blocked(self, page: Page) -> None:
        url = page.url.lower()
        text = (await page.locator("body").inner_text(timeout=5000)).lower()
        if "accounts.google.com" in url:
            raise BrowserBlockedError("Google login is required in the connected Chrome profile.")
        if "/sorry/" in url:
            raise BrowserBlockedError("Google blocked the request with an automated-traffic page.")
        if any(marker in text for marker in BLOCK_TEXT_MARKERS):
            raise BrowserBlockedError("The page appears to require login, consent, CAPTCHA, or verification.")

    async def _try_start_new_gemini_chat(self, page: Page) -> None:
        selectors = [
            'a[aria-label*="New chat"]',
            'button[aria-label*="New chat"]',
            'a[aria-label*="新しいチャット"]',
            'button[aria-label*="新しいチャット"]',
        ]
        for selector in selectors:
            locator = page.locator(selector).first
            try:
                if await locator.count() and await locator.is_visible(timeout=1000):
                    await locator.click()
                    await page.wait_for_timeout(1000)
                    return
            except Exception:
                continue

    async def _find_gemini_input(self, page: Page):
        selectors = [
            'rich-textarea div[contenteditable="true"]',
            'div[contenteditable="true"][role="textbox"]',
            'div[contenteditable="true"][aria-label*="prompt" i]',
            'div[contenteditable="true"]',
            'textarea',
        ]
        for selector in selectors:
            locator = page.locator(selector).last
            try:
                if await locator.count() and await locator.is_visible(timeout=2000):
                    return locator
            except Exception:
                continue
        raise PageInteractionError("Could not find the Gemini prompt input. Confirm Gemini Web UI is usable.")

    async def _submit_gemini_prompt(self, page: Page) -> None:
        button_selectors = [
            'button[aria-label*="Send" i]',
            'button[aria-label*="Submit" i]',
            'button[aria-label*="送信"]',
        ]
        for selector in button_selectors:
            locator = page.locator(selector).last
            try:
                if await locator.count() and await locator.is_visible(timeout=1000):
                    await locator.click()
                    return
            except Exception:
                continue
        await page.keyboard.press("Enter")

    async def _gemini_response_candidates(self, page: Page) -> list[str]:
        script = """
        () => {
          const selectors = [
            'message-content',
            '.model-response-text',
            'div.markdown',
            'div[role="article"]',
            '[data-response-index]'
          ];
          const values = [];
          for (const selector of selectors) {
            for (const node of document.querySelectorAll(selector)) {
              const text = (node.innerText || '').trim();
              if (text.length > 20) values.push(text);
            }
          }
          return values;
        }
        """
        values = await page.evaluate(script)
        return [clean_text(value) for value in values if clean_text(value)]

    async def _gemini_response_links(self, page: Page, answer_text: str) -> list[str]:
        script = """
        (answerText) => {
          const selectors = [
            'message-content',
            '.model-response-text',
            'div.markdown',
            'div[role="article"]',
            '[data-response-index]'
          ];
          const normalize = (value) => (value || '').replace(/\\s+/g, ' ').trim();
          const normalizedAnswer = normalize(answerText);
          let bestNode = null;
          for (const selector of selectors) {
            for (const node of document.querySelectorAll(selector)) {
              const text = normalize(node.innerText);
              if (!text || text.length < 20) continue;
              if (text === normalizedAnswer || text.includes(normalizedAnswer) || normalizedAnswer.includes(text)) {
                bestNode = node;
              }
            }
          }
          if (!bestNode) return [];
          return Array.from(bestNode.querySelectorAll('a[href]')).map((anchor) => anchor.href);
        }
        """
        urls = await page.evaluate(script, answer_text)
        return normalize_links(urls)

    async def _wait_for_gemini_answer(
        self,
        page: Page,
        before: list[str],
        timeout_ms: int,
    ) -> str:
        before_set = set(before)
        deadline = time.monotonic() + timeout_ms / 1000
        last_answer = ""
        stable_count = 0

        while time.monotonic() < deadline:
            await self._raise_if_blocked(page)
            candidates = await self._gemini_response_candidates(page)
            new_candidates = [candidate for candidate in candidates if candidate not in before_set]
            candidate = new_candidates[-1] if new_candidates else (candidates[-1] if candidates else "")

            if candidate and candidate == last_answer:
                stable_count += 1
            else:
                stable_count = 0
                last_answer = candidate

            if last_answer and stable_count >= 3:
                return last_answer

            await asyncio.sleep(1)

        raise PageInteractionError("Timed out waiting for Gemini response text to stabilize.")


def _elapsed_ms(started: float) -> int:
    return int((time.monotonic() - started) * 1000)


def normalize_browser_error(exc: Exception) -> McpSearchError:
    if isinstance(exc, McpSearchError):
        return exc
    if isinstance(exc, PlaywrightError):
        message = str(exc)
        lower_message = message.lower()
        if "connect" in lower_message or "ecconnrefused" in lower_message:
            return ChromeConnectionError(
                "Chrome CDP is not reachable. Start the dedicated Chrome profile with "
                "./scripts/start_chrome_cdp.sh and verify http://127.0.0.1:9222/json/version."
            )
        return PageInteractionError(f"Browser operation failed: {message}")
    return PageInteractionError(f"Unexpected browser operation failed: {exc}")
