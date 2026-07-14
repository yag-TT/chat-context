# opencode-multi-agent

[English](README.md)

`opencode-multi-agent` は、OpenCode 向けのローカル
マルチエージェント・オーケストレーション plugin です。この展開済みフォルダ
から直接インストールし、npm や GitHub には公開しません。

## 必要なもの

- OpenCode
- Bun
- 展開済みの完全な本フォルダ

## インストール

本フォルダでターミナルを開き、次を実行します。

```bash
bun install
bun run install:local
```

インストーラは plugin をビルドし、本フォルダの絶対パスを OpenCode と TUI の
`plugin` 配列へ登録します。また、`opencode-multi-agent.schema.json` を指す
絶対 `file://` URL を含む plugin 設定を作成します。

本フォルダを移動、差し替え、再展開した場合は、移動先で両コマンドを再実行して
ください。

設定ファイルは次の場所に保存されます。

```text
~/.config/opencode/opencode-multi-agent.json[c]
<project>/.opencode/opencode-multi-agent.json[c]
```

インストーラのオプション、診断、更新、削除方法は
[ローカルインストール手順](docs/installation.md) を参照してください。
