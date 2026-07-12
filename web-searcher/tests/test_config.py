import pytest
from pydantic import ValidationError

from chrome_gemini_mcp.config import Settings


def test_cdp_url_must_be_localhost_ip():
    with pytest.raises(ValidationError):
        Settings(chrome_cdp_url="http://localhost:9222")


def test_cdp_url_requires_port():
    with pytest.raises(ValidationError):
        Settings(chrome_cdp_url="http://127.0.0.1")


def test_default_settings_are_valid():
    settings = Settings()
    assert settings.chrome_cdp_url == "http://127.0.0.1:9222"
