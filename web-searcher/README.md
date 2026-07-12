# Chrome Gemini MCP

OpenCodeから利用するためのPython製MCPサーバーです。既存のGoogle
ChromeへChrome DevTools Protocol（CDP）で接続し、ログイン済みのGemini
Web UI、通常のGoogle検索、ページ本文取得をローカルツールとして提供します。

有料のWeb検索API、DuckDuckGo、SearXNG、Gemini API / Vertex AIは使用しません。

## セキュリティ方針

- MCPサーバーは `http://127.0.0.1:<port>` のCDPエンドポイントにだけ接続します。
- 通常のChromeプロファイルは使用しません。
- ChromeのCookieを直接読み取りません。
- 専用Chromeプロファイル上で一時タブを開き、各ツール実行後に閉じます。
- CAPTCHA、追加ログイン、同意画面、ブロック画面は突破せず、明示的なエラーとして返します。

## インストール

PowerShellでこのプロジェクトディレクトリに移動して実行します。

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -e ".[dev]"
python -m playwright install
```

`python -m playwright install` はPlaywrightの実行環境準備用です。このMCPは、
Playwright同梱ブラウザではなく、インストール済みのGoogle ChromeへCDP接続します。

## CDP付きChromeの起動

Chrome 136以降では、通常のChromeプロファイルに対する
`--remote-debugging-port` が無視されます。そのため、このMCPでは専用プロファイルを
使います。通常のChromeとは別に起動でき、Geminiへのログインは初回だけ必要です。

Git Bash、WSL、またはBash互換シェルから以下を実行します。

```bash
./scripts/start_chrome_cdp.sh
```

Chromeのインストール場所が自動検出できない場合は、`CHROME_PATH` を指定します。

```bash
CHROME_PATH="/c/Program Files/Google/Chrome/Application/chrome.exe" ./scripts/start_chrome_cdp.sh
```

手動で起動する場合は以下です。

```bash
LOCAL_APP_DATA_DIR="$(cygpath -u "$LOCALAPPDATA" 2>/dev/null || printf '%s' "$HOME/AppData/Local")"
USER_DATA_DIR="$LOCAL_APP_DATA_DIR/ChromeGeminiMcp/User Data"
mkdir -p "$USER_DATA_DIR"

"/c/Program Files/Google/Chrome/Application/chrome.exe" \
  --remote-debugging-port=9222 \
  --remote-debugging-address=127.0.0.1 \
  --user-data-dir="$USER_DATA_DIR" \
  "https://gemini.google.com/"
```

CDPが起動しているか確認します。

```bash
curl http://127.0.0.1:9222/json/version
```

`Browser` や `webSocketDebuggerUrl` が返れば成功です。初回は、起動した専用Chromeで
<https://gemini.google.com/> にアクセスし、会社アカウントでログインしてください。

### UIを開かずに起動する

専用Chromeプロファイルでの初回ログインを通常版で済ませた後は、headless版を使うと
Chromeのウィンドウを表示せずにCDPを起動できます。

```bash
./scripts/start_chrome_cdp_headless.sh
```

`PORT`、`USER_DATA_DIR`、`CHROME_PATH` は通常版と同じように指定できます。

```bash
PORT=9223 CHROME_PATH="/c/Program Files/Google/Chrome/Application/chrome.exe" \
  ./scripts/start_chrome_cdp_headless.sh
```

通常版とheadless版を同じプロファイルで同時に起動することはできません。切り替える場合は、
先に起動中の専用Chromeを終了してください。ログイン期限切れや追加認証が発生した場合も、
通常版を起動して画面上でログインし直してください。

### Chromeを停止する

通常版とheadless版のどちらも、以下のスクリプトで停止できます。

```bash
./scripts/stop_chrome_cdp.sh
```

起動時に別のCDPポートを指定した場合は、停止時にも同じポートを指定します。

```bash
PORT=9223 ./scripts/stop_chrome_cdp.sh
```

CDPポートが一致するChromeプロセスだけを停止するため、通常のChromeは停止しません。

## OpenCode設定

`opencode.json` に以下を追加します。

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "chrome_gemini_search": {
      "type": "local",
      "command": [
        "D:/work/Develop/LLM/web-searcher/.venv/Scripts/python.exe",
        "-m",
        "chrome_gemini_mcp.server"
      ],
      "cwd": "D:/work/Develop/LLM/web-searcher",
      "enabled": true,
      "environment": {
        "CHROME_CDP_URL": "http://127.0.0.1:9222"
      }
    }
  }
}
```

依存関係をグローバルPythonにインストールした場合は、`command` を次のようにできます。

```jsonc
["python", "-m", "chrome_gemini_mcp.server"]
```

## 利用できるツール

- `gemini_web_search(query, timeout_sec=90)`
  - Gemini Web UIを開き、Web検索を使った回答と参照URLを取得します。
- `google_search(query, max_results=5, language="ja", region="JP")`
  - 通常のGoogle検索結果ページから、タイトル、URL、スニペットを抽出します。
- `fetch_page(url, max_chars=6000)`
  - 指定URLをChromeで開き、表示本文を取得します。

OpenCodeでは、例えば次のように依頼できます。

```text
chrome_gemini_searchを使って、Python 3.13の新機能を調べてください。参照URLも表示してください。
```

## 環境変数

- `CHROME_CDP_URL`
  - 既定値: `http://127.0.0.1:9222`
- `GEMINI_URL`
  - 既定値: `https://gemini.google.com/app`
- `GOOGLE_SEARCH_BASE_URL`
  - 既定値: `https://www.google.com/search`
- `SEARCH_TIMEOUT_MS`
  - 既定値: `30000`
- `CHROME_HEADLESS`
  - `scripts/start_chrome_cdp.sh` に `1` を指定すると、ChromeをUIなしで起動します。
  - MCPサーバー自身はこの値を使用しません。通常は
    `scripts/start_chrome_cdp_headless.sh` を使用してください。
- `CHROME_LOG_FILE`
  - Chromeの標準出力と標準エラーを保存するファイルです。既定では破棄します。

## テスト

```powershell
python -m pytest
```

ライブChromeを使う統合テストは自動実行しません。ログイン済みの専用Chromeセッションが
必要になるためです。

## トラブルシューティング

### `Chrome CDP is not reachable` が返る

CDP付きChromeが起動していないか、OpenCodeから見えるポートが違います。

```bash
curl http://127.0.0.1:9222/json/version
```

これが失敗する場合は、以下で起動し直してください。

```bash
./scripts/start_chrome_cdp.sh
```

### Geminiのログイン画面が出る

専用ChromeプロファイルでGeminiにログインしてください。通常Chromeのログイン状態は使いません。

### Google検索やGeminiがブロック画面になる

CAPTCHAや自動化ブロックは突破しません。時間を置く、検索回数を減らす、または手動で
Gemini Web UIを確認してください。
