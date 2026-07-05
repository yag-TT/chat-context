# Flutter MVVM Demo 設計書

本プロジェクトは、FlutterでMVVM構成を試すためのサンプルアプリです。
ChromeでのWeb実行を前提に、天気、IoT操作、通知、設定の4画面を持ちます。

詳細設計は責務ごとに分割しています。

- [アーキテクチャ](architecture.md)
- [画面設計](screens.md)
- [Repository設計](repositories.md)
- [ViewModel設計](viewmodels.md)
- [テストと実行](testing.md)

アプリ本体は `mobile_app` 配下にあります。

## 画面

- ホーム画面: 天気アプリ風のモック天気表示
- 検索画面: IoTデバイス操作ダッシュボード
- 通知画面: Repositoryから取得したモック通知一覧と詳細表示
- 設定画面: 通知、IoT連携、表示設定のモック操作

## 基本構成

```text
View
  -> ViewModel
    -> Repository
      -> Mock Data / Local Storage
```

Repository実装は `AppDependencies` に集約し、アプリ起点から画面へ渡します。
ViewModelはRepositoryインターフェースを受け取り、Mock実装を直接生成しません。
Chrome版のIoT操作設定はRepository経由でブラウザのLocal Storageに保存し、リロード後も設定を引き継ぎます。
