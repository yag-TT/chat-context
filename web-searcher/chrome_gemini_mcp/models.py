from __future__ import annotations

from pydantic import BaseModel, Field, HttpUrl


class SearchResult(BaseModel):
    title: str
    url: str
    snippet: str = ""


class SearchResponse(BaseModel):
    query: str
    source: str
    results: list[SearchResult]
    elapsed_ms: int


class GeminiResponse(BaseModel):
    query: str
    source: str = "gemini_web_ui"
    answer_markdown: str
    references: list[str] = Field(default_factory=list)
    elapsed_ms: int


class FetchPageResponse(BaseModel):
    url: HttpUrl
    title: str = ""
    text: str
    truncated: bool
    elapsed_ms: int
