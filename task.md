以下の進め方が安全です。ポイントは **Planで把握、Buildで小修正** です。OpenCode公式でも、Plan agentは変更せず分析・提案に使う用途とされています。([OpenCode][1])

## 1. まずGitで退避

```bash
git status
git checkout -b poc-audit
git add .
git commit -m "chore: backup inherited Flutter PoC"
```

未コミット変更が多いなら、最初に絶対コミットしてください。

## 2. opencodeでは最初に「修正禁止」で調査

Planで以下を投げます。

```text
このFlutter PoCを修正せずに調査してください。
目的は、プロジェクト構成、使用技術、起動方法、主要画面、状態管理、API/DB/外部連携、未実装/壊れている可能性がある箇所を把握することです。

次をMarkdownで出してください。
1. プロジェクト概要
2. ディレクトリ構成
3. 起動方法
4. 主要機能
5. 依存パッケージ
6. 修正が必要そうな箇所
7. 優先度付きTODO
8. 次に確認すべきコマンド
ファイル変更は禁止です。
```

## 3. Flutter側の確認コマンド

opencodeに実行させるか、自分で実行します。

```bash
flutter doctor -v
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Android確認もするなら：

```bash
flutter devices
flutter run -d <device-id>
```

## 4. 洗い出し観点

最低限これを見ます。

| 観点    | 確認内容                                         |
| ----- | -------------------------------------------- |
| 起動    | `flutter run` できるか                           |
| 依存    | `pubspec.yaml` が古すぎないか                       |
| 画面    | 主要画面がどこにあるか                                  |
| 状態管理  | Provider / Riverpod / Bloc / GetX / setState |
| 通信    | API URL、認証、mock有無                            |
| 永続化   | SQLite / Hive / SharedPreferences            |
| エラー   | analyze / test / runtime error               |
| PoC残骸 | TODO、仮実装、ハードコード                              |
| 設計    | MVVM/Clean Architectureに寄せられるか               |

## 5. AGENTS.mdを作る

OpenCodeは`AGENTS.md`でプロジェクトルールを渡せます。([OpenCode][2])

```md
# AGENTS.md

## 方針
- Flutter PoCの引き継ぎ開発を行う
- まず既存挙動を壊さない
- 大規模リファクタより、小さい修正を優先
- 変更前に必ず対象ファイルと意図を説明する

## 禁止
- 勝手に大規模なディレクトリ再構成をしない
- 動作確認なしで完了扱いにしない
- pubspec.yamlの大幅更新を勝手にしない

## 確認コマンド
- flutter analyze
- flutter test
- flutter run -d chrome
```

## 6. 修正は1件ずつBuildに渡す

例：

```text
flutter analyze のエラーを1種類だけ修正してください。
修正前に原因と対象ファイルを説明してください。
修正後に flutter analyze を再実行してください。
```

一気に「全部直して」は避けた方が良いです。

## おすすめ順序

1. 起動確認
2. `flutter analyze` 修正
3. テストがあれば `flutter test`
4. 画面遷移と主要機能の把握
5. ハードコード/API/mockの整理
6. TODOリスト作成
7. 優先度Highだけ修正
8. README更新

最初のゴールは **完成させることではなく、壊れている場所と直す順番を明確にすること** です。

[1]: https://opencode.ai/docs/agents/?utm_source=chatgpt.com "Agents"
[2]: https://opencode.ai/docs/rules/?utm_source=chatgpt.com "Rules"
