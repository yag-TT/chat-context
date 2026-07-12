from __future__ import annotations

from typing import Any

from fastmcp import FastMCP

from chrome_gemini_mcp.browser import ChromeGeminiClient, normalize_browser_error
from chrome_gemini_mcp.config import load_settings


mcp = FastMCP("chrome-gemini-search")


def _client() -> ChromeGeminiClient:
    return ChromeGeminiClient(load_settings())


def _as_tool_error(exc: Exception) -> dict[str, Any]:
    return {
        "ok": False,
        "error_type": exc.__class__.__name__,
        "error": str(exc),
    }


@mcp.tool
async def gemini_web_search(query: str, timeout_sec: int = 90) -> dict[str, Any]:
    """Ask logged-in Gemini Web UI to search the web and answer with source URLs."""
    try:
        response = await _client().gemini_web_search(query=query, timeout_sec=timeout_sec)
        return {"ok": True, **response.model_dump(mode="json")}
    except Exception as exc:
        return _as_tool_error(normalize_browser_error(exc))


@mcp.tool
async def google_search(
    query: str,
    max_results: int = 5,
    language: str = "ja",
    region: str = "JP",
) -> dict[str, Any]:
    """Extract organic results from a normal Google Search page in Chrome."""
    try:
        response = await _client().google_search(
            query=query,
            max_results=max_results,
            language=language,
            region=region,
        )
        return {"ok": True, **response.model_dump(mode="json")}
    except Exception as exc:
        return _as_tool_error(normalize_browser_error(exc))


@mcp.tool
async def fetch_page(url: str, max_chars: int = 6000) -> dict[str, Any]:
    """Fetch visible page text through the connected Chrome session."""
    try:
        response = await _client().fetch_page(url=url, max_chars=max_chars)
        return {"ok": True, **response.model_dump(mode="json")}
    except Exception as exc:
        return _as_tool_error(normalize_browser_error(exc))


def main() -> None:
    mcp.run()


if __name__ == "__main__":
    main()
