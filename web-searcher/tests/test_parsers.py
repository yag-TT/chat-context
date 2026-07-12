from chrome_gemini_mcp.parsers import (
    extract_google_results,
    extract_http_links_from_html,
    normalize_links,
    normalize_google_url,
)


def test_normalize_google_redirect_url():
    assert (
        normalize_google_url("/url?q=https%3A%2F%2Fexample.com%2Fdocs&sa=U")
        == "https://example.com/docs"
    )


def test_normalize_full_google_redirect_url():
    assert (
        normalize_google_url("https://www.google.com/url?q=https%3A%2F%2Fexample.com%2Fdocs&sa=U")
        == "https://example.com/docs"
    )


def test_normalize_google_url_filters_google_hosts():
    assert normalize_google_url("https://www.google.com/preferences") is None


def test_extract_google_results_from_fixture():
    html = """
    <html>
      <body>
        <div id="search">
          <div class="g">
            <a href="/url?q=https%3A%2F%2Fexample.com%2Falpha&sa=U">
              <h3>Alpha Result</h3>
            </a>
            <div class="VwiC3b">Alpha snippet text.</div>
          </div>
          <div class="g">
            <a href="https://example.org/beta">
              <h3>Beta Result</h3>
            </a>
            <span class="aCOpRe">Beta snippet text.</span>
          </div>
        </div>
      </body>
    </html>
    """

    results = extract_google_results(html, max_results=5)

    assert [result.title for result in results] == ["Alpha Result", "Beta Result"]
    assert results[0].url == "https://example.com/alpha"
    assert results[1].snippet == "Beta snippet text."


def test_extract_http_links_normalizes_google_redirects():
    html = """
    <a href="https://www.google.com/url?q=https%3A%2F%2Fexample.com%2Fsource&sa=U">source</a>
    <a href="https://support.google.com/gemini">help</a>
    """

    assert extract_http_links_from_html(html) == ["https://example.com/source"]


def test_normalize_links_does_not_reparse_as_html():
    links = [
        'https://example.com/source?title=a"b&x=1',
        "https://support.google.com/gemini",
        "https://www.google.com/url?q=https%3A%2F%2Fexample.org%2Fdoc%3Fa%3D1%26b%3D2&sa=U",
    ]

    assert normalize_links(links) == [
        'https://example.com/source?title=a"b&x=1',
        "https://example.org/doc?a=1&b=2",
    ]
