from __future__ import annotations

import os
from urllib.parse import urlparse

from pydantic import BaseModel, Field, field_validator


class Settings(BaseModel):
    chrome_cdp_url: str = Field(default="http://127.0.0.1:9222")
    gemini_url: str = Field(default="https://gemini.google.com/app")
    google_search_base_url: str = Field(default="https://www.google.com/search")
    search_timeout_ms: int = Field(default=30_000, ge=5_000, le=180_000)

    @field_validator("chrome_cdp_url")
    @classmethod
    def validate_local_cdp_url(cls, value: str) -> str:
        parsed = urlparse(value)
        if parsed.scheme not in {"http", "https"}:
            raise ValueError("CHROME_CDP_URL must use http or https")
        if parsed.hostname != "127.0.0.1":
            raise ValueError("CHROME_CDP_URL must be bound to 127.0.0.1")
        if parsed.port is None:
            raise ValueError("CHROME_CDP_URL must include a port")
        return value.rstrip("/")

    @field_validator("gemini_url", "google_search_base_url")
    @classmethod
    def validate_https_url(cls, value: str) -> str:
        parsed = urlparse(value)
        if parsed.scheme != "https":
            raise ValueError("Gemini and Google Search URLs must use https")
        return value.rstrip("/")


def load_settings() -> Settings:
    return Settings(
        chrome_cdp_url=os.getenv("CHROME_CDP_URL", "http://127.0.0.1:9222"),
        gemini_url=os.getenv("GEMINI_URL", "https://gemini.google.com/app"),
        google_search_base_url=os.getenv(
            "GOOGLE_SEARCH_BASE_URL", "https://www.google.com/search"
        ),
        search_timeout_ms=int(os.getenv("SEARCH_TIMEOUT_MS", "30000")),
    )
