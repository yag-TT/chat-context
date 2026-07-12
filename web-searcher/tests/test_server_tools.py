from chrome_gemini_mcp.server import fetch_page, gemini_web_search, google_search


def test_server_exports_expected_tools():
    assert callable(gemini_web_search)
    assert callable(google_search)
    assert callable(fetch_page)
