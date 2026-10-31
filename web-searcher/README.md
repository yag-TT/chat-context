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

- `gemini_ask(prompt, context="", timeout_sec=300)`
  - 複雑な設計判断、デバッグ、コードレビュー、実装案の比較をGeminiに依頼します。
  - `context` が空の場合、`prompt` をそのまま送信します。指定した場合は末尾に文脈として追加します。
  - 呼び出しごとに新しいチャットで依頼します。前回の会話は引き継ぎません。
  - 待機時間は10〜600秒です。呼び出し側のMCPタイムアウトも、処理時間に余裕を持たせて設定してください。
  - 戻り値は検索と同じ `query`、`source`、`answer_markdown`、`references`、`elapsed_ms` と `ok` です。`query` は元の `prompt` です。
  - モデルや思考モードはUIの設定に従います。このツールはモードを切り替えません。
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

### ローカルのコーディングエージェントから利用する

エージェントの指示には、例えば次を追加してください。

```text
修正コード・実装コード・使用例・テストの生成、
複雑な設計判断、原因が不明なバグ、コードレビュー、実装案の比較、
自分の回答の独立した検証には gemini_ask を使う。
最新の仕様や外部情報の調査には gemini_web_search を使う。

gemini_ask には目的、関連コード、実行環境、制約、エラー、試したこと、
期待する成果物を渡す。Geminiはローカルファイルの閲覧やテスト実行ができないため、
パスだけではなく必要な内容をcontextに含める。認証情報は含めない。
送信前にpromptとcontextの両方を匿名化する。プロジェクト名、会社名、顧客名、
リポジトリ名、内部ドメイン、絶対パス、固有のパッケージ名・識別子を仮名に置換する。
コメント、import、文字列、ログ、スタックトレース、設定、URL内の名前も確認する。
同一の名前は全ファイルで同じ仮名に統一し、参照関係を保つ。
ファイルパスは中立的な相対パスにする。公開ライブラリや標準APIの名前は維持する。
元の名前と仮名の対応表はローカルだけで保持し、Geminiには送信しない。
返されたコードの仮名はローカルで元に戻してから適用し、テストする。
呼び出し前に関連ファイルを読み、対象実装だけでなく、必要に応じて呼び出し元、
型・インターフェース、依存関係とバージョン、既存テストも収集する。
各コードにはファイルパスと、全文か抜粋かを明記する。抜粋時は関数・クラスの
境界や必要なimportを含め、今回の課題に必要な範囲を渡す。
バグ修正では再現手順、期待動作、実際の動作、スタックトレースも渡す。
回答には対象パス付きの具体的な修正コードまたはunified diff、使用例、
テストコードと実行方法を要求する。不明なAPIは作らず、不足情報と仮定を明記させる。
Geminiの提案は実際のコードと照合し、必要なテストで検証してから採用する。
追加依頼でも会話は引き継がれないため、必要なコードと前回の提案・検証結果を再度渡す。
```

依頼例:

```text
gemini_ask(
  prompt="この非同期処理の競合を調べ、発生条件と最小限の修正案、確認すべきテストを示してください。不足する情報と仮定も明記してください。",
  context="目的: ...\n環境: Python 3.12\n関連コード: ...\nエラー: ...\n試したこと: ...",
  timeout_sec=300
)
```

コード生成を依頼する際の `prompt` と `context` の例です。
以下のテンプレートに実際のファイル内容を埋めて送ります。

````text
prompt:
提示した既存コードに合わせてバグを修正してください。
1. 原因と再現条件
2. 対象パス付きのunified diff（新規ファイルは全文）
3. 修正後のAPIを呼び出す具体的な使用例
4. 回帰テストのコードと実行コマンド
5. 不足情報と仮定、未検証の点
を返してください。既存の公開APIとの互換性を維持し、
提示されていないプロジェクト固有APIを推測で作らないでください。

context:
## 課題
目的: ...
環境・依存バージョン: ...
再現手順: ...
期待動作: ...
実際の動作・エラー: ...
制約・試したこと: ...

## src/service.py（全文）
```python
<実際の実装>
```

## src/caller.py（抜粋: 対象APIの呼び出し元）
```python
<関連するimportと呼び出し処理>
```

## tests/test_service.py（全文）
```python
<既存のテストとfixture>
```
````

現在の `context` は文字列で、ファイル内容は呼び出し側のエージェントが収集します。
MCPサーバーがパスからファイルを読み込む処理はありません。
大量のコードが必要な場合は課題を分割し、それぞれに必要なコードを含めます。

### 固有名を含めずにコードを渡す

呼び出し側で「関連コード収集 → 匿名化 → 送信内容確認 → Geminiへの依頼 →
回答中の仮名を復元 → 適用・テスト」の順に処理します。
例えばローカルに `ProjectName → ProjectA`、`CompanyName → OrganizationA`、
固有のパッケージ名 `internal_product → sample_app` の対応を保持し、
送信するコード・説明・パスに同じ置換を適用します。対応表そのものは送信しません。

送信例（元の固有名や絶対パスは含めません）:

````text
prompt:
次のコードのバグを修正し、使用例と回帰テストを返してください。
コードとパスは匿名化済みです。提示された仮名を維持してください。

context:
## src/sample_app/service.py（関連箇所の抜粋）
```python
from sample_app.models import Item

def find_item(items: list[Item], item_id: str) -> Item:
    return next(item for item in items if item.id == item_id)
```
期待動作: 対象が存在しないときはNoneを返す。
実際の動作: StopIterationが発生する。
````

この匿名化は呼び出し側エージェントへの指示です。MCPサーバーには自動匿名化や
送信拒否の機能がなく、受け取った文字列を送信します。指示だけでは伏せ漏れを
保証できません。固有名の送信を確実に禁止する必要がある場合は、別途ローカルで管理する
禁止語一覧と照合し、残存時に送信を拒否する検査が必要です。
単純な文字列置換でも表記揺れや文脈からの推測は防げないため、必要な範囲だけを渡します。

回答の取得は生成停止ボタンの表示とテキストの安定を確認します。
GeminiのUI変更により、セレクターの調整が必要になる場合があります。

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
