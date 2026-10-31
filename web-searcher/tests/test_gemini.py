from unittest.mock import AsyncMock

import pytest

from chrome_gemini_mcp.browser import ChromeGeminiClient
from chrome_gemini_mcp.config import Settings
from chrome_gemini_mcp.errors import PageInteractionError


@pytest.mark.asyncio
async def test_ask_preserves_prompt_and_allows_long_timeout():
    client = ChromeGeminiClient(Settings())
    client._gemini_request = AsyncMock()
    prompt = "Review this code.\n  Preserve formatting."
    await client.gemini_ask(prompt, timeout_sec=600)
    client._gemini_request.assert_awaited_once_with(prompt, prompt, 600)


@pytest.mark.asyncio
async def test_ask_includes_context():
    client = ChromeGeminiClient(Settings())
    client._gemini_request = AsyncMock()
    await client.gemini_ask("Find the bug", context="def example(): pass")
    client._gemini_request.assert_awaited_once_with(
        "Find the bug\n\n<context>\ndef example(): pass\n</context>",
        "Find the bug", 300,
    )


@pytest.mark.asyncio
@pytest.mark.parametrize("prompt, timeout", [("  ", 300), ("Review", 9), ("Review", 601)])
async def test_ask_rejects_invalid_input(prompt, timeout):
    client = ChromeGeminiClient(Settings())
    with pytest.raises(PageInteractionError):
        await client.gemini_ask(prompt, timeout_sec=timeout)


@pytest.mark.asyncio
async def test_search_keeps_search_instructions():
    client = ChromeGeminiClient(Settings())
    client._gemini_request = AsyncMock()
    await client.gemini_web_search("Python", timeout_sec=90)
    message, query, timeout = client._gemini_request.call_args.args
    assert "Web検索" in message
    assert "質問: Python" in message
    assert (query, timeout) == ("Python", 90)


@pytest.mark.asyncio
async def test_wait_ignores_old_answer_and_generation_pause(monkeypatch):
    client = ChromeGeminiClient(Settings())
    client._raise_if_blocked = AsyncMock()
    client._gemini_response_candidates = AsyncMock(side_effect=[
        ["old"], ["old"], ["old"], ["old"],
        ["old", "partial"], ["old", "partial"],
        ["old", "partial"], ["old", "partial"],
        ["old", "OK"], ["old", "OK"], ["old", "OK"], ["old", "OK"],
    ])
    client._gemini_is_generating = AsyncMock(side_effect=[False] * 4 + [True] * 4 + [False] * 4)
    monkeypatch.setattr("chrome_gemini_mcp.browser.asyncio.sleep", AsyncMock())
    answer = await client._wait_for_gemini_answer(object(), ["old"], 10_000)
    assert answer == "OK"
    assert client._gemini_response_candidates.await_count == 12
