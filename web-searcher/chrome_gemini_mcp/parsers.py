from __future__ import annotations

from urllib.parse import parse_qs, unquote, urlparse

from bs4 import BeautifulSoup

from chrome_gemini_mcp.models import SearchResult


GOOGLE_HOST_SUFFIXES = (
    ".google.com",
    ".google.co.jp",
    ".googleusercontent.com",
    ".gstatic.com",
)


def clean_text(text: str) -> str:
    return " ".join(text.split())


def normalize_google_url(href: str) -> str | None:
    if not href:
        return None
    parsed_href = urlparse(href)
    if href.startswith("/url?") or (
        parsed_href.hostname
        and (parsed_href.hostname == "google.com" or parsed_href.hostname.endswith(".google.com"))
        and parsed_href.path == "/url"
    ):
        query = parse_qs(parsed_href.query)
        href = query.get("q", [""])[0]
    if href.startswith("/search?") or href.startswith("#"):
        return None
    href = unquote(href)
    parsed = urlparse(href)
    if parsed.scheme not in {"http", "https"}:
        return None
    host = parsed.hostname or ""
    if host == "google.com" or any(host.endswith(suffix) for suffix in GOOGLE_HOST_SUFFIXES):
        return None
    return href


def extract_google_results(html: str, max_results: int) -> list[SearchResult]:
    soup = BeautifulSoup(html, "html.parser")
    results: list[SearchResult] = []
    seen: set[str] = set()

    containers = soup.select("#search div.g, #search div.MjjYud, div[data-sokoban-container]")
    if not containers:
        containers = soup.select("div")

    for container in containers:
        heading = container.find("h3")
        if heading is None:
            continue
        link = heading.find_parent("a") or container.find("a", href=True)
        if link is None:
            continue
        url = normalize_google_url(link.get("href", ""))
        if not url or url in seen:
            continue

        title = clean_text(heading.get_text(" "))
        if not title:
            continue

        snippet = extract_snippet(container, title)
        results.append(SearchResult(title=title, url=url, snippet=snippet))
        seen.add(url)
        if len(results) >= max_results:
            break

    return results


def extract_snippet(container, title: str) -> str:
    selectors = [
        "div.VwiC3b",
        "span.aCOpRe",
        "div.IsZvec",
        "div[data-sncf]",
    ]
    for selector in selectors:
        node = container.select_one(selector)
        if node:
            text = clean_text(node.get_text(" "))
            if text and text != title:
                return text

    text = clean_text(container.get_text(" "))
    if text.startswith(title):
        text = text[len(title) :].strip()
    return text[:500]


def extract_http_links_from_html(html: str) -> list[str]:
    soup = BeautifulSoup(html, "html.parser")
    return normalize_links(anchor["href"] for anchor in soup.find_all("a", href=True))


def normalize_links(urls) -> list[str]:
    links: list[str] = []
    seen: set[str] = set()
    for href in urls:
        url = normalize_google_url(href)
        if url is None and _is_google_http_url(href):
            continue
        if url is None:
            url = href
        parsed = urlparse(url)
        if parsed.scheme not in {"http", "https"}:
            continue
        if url not in seen:
            links.append(url)
            seen.add(url)
    return links


def _is_google_http_url(url: str) -> bool:
    parsed = urlparse(url)
    host = parsed.hostname or ""
    return parsed.scheme in {"http", "https"} and (
        host == "google.com" or any(host.endswith(suffix) for suffix in GOOGLE_HOST_SUFFIXES)
    )
