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
async def gemini_ask(
    prompt: str, context: str = "", timeout_sec: int = 300
) -> dict[str, Any]:
    """Ask Gemini to analyze bugs, generate fixes, implementation code, usage examples,
    tests, architecture proposals, or code reviews. Before calling, read the relevant
    local files and include their contents in context, labeled with paths and whether
    each is complete or an excerpt. Include callers, interfaces/types, dependencies,
    existing tests, reproduction steps, errors, constraints and expected behavior as
    needed. File paths alone are insufficient: Gemini cannot read your repository or
    run tests. Request concrete code or a unified diff with target paths, usage examples,
    verification steps and explicit assumptions; do not invent missing project APIs.
    Review the returned code against local files, apply it and run relevant checks.
    Include only task-relevant content and exclude credentials/secrets.
    Before sending, anonymize project/company/customer names, internal domains,
    repository names, local absolute paths and proprietary identifiers in both prompt
    and context (including code, comments, imports and logs). Use consistent aliases
    preserving symbol relationships; keep the reverse mapping local and restore names
    locally in the returned code. Use neutral relative file paths. Preserve public
    library/API names needed for correctness. This tool sends supplied text as-is;
    it does not automatically anonymize or guarantee removal of sensitive names.
    Sends prompt unchanged when context is empty. Each call starts a fresh chat;
    follow-ups must include the necessary context again. Returns generated text,
    not local edits or executed test results.
    timeout_sec must be between 10 and 600; configure the caller's tool timeout accordingly.
    """
    try:
        response = await _client().gemini_ask(
            prompt=prompt, context=context, timeout_sec=timeout_sec
        )
        return {"ok": True, **response.model_dump(mode="json")}
    except Exception as exc:
        return _as_tool_error(normalize_browser_error(exc))


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
