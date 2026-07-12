from __future__ import annotations


class McpSearchError(RuntimeError):
    """Base error for user-facing MCP search failures."""


class ChromeConnectionError(McpSearchError):
    """Raised when Chrome CDP is not reachable."""


class BrowserBlockedError(McpSearchError):
    """Raised for login, CAPTCHA, consent, or automated-traffic blocks."""


class PageInteractionError(McpSearchError):
    """Raised when a browser page cannot be operated as expected."""
