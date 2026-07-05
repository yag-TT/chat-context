# アーキテクチャ

基本構成はMVVMです。

```text
View
  -> ViewModel
    -> Repository
      -> Mock Data / Local Storage
```

## 責務

- View: Widgetの描画、ユーザー操作の受付
- ViewModel: 表示状態、選択状態、操作状態、Repository呼び出し
- Repository: データ取得/保存インターフェース、モック実装、ローカル保存実装
- Model: 画面表示に使うデータ構造

## 依存注入

Repository実装は `AppDependencies` に集約し、`MyApp` から `HomePage` へ渡します。
モックデータ本体は `core/mock_data` に分け、Mock Repositoryは取得口として振る舞います。
Chrome実行時は `AppDependencies.local()` を使い、IoT操作設定は `shared_preferences` 経由でブラウザのLocal Storageに保存します。
Widgetテストでは `AppDependencies.mock()` を使い、IoT操作設定はインメモリRepositoryで扱います。
アプリ全体のテーマ定義は `AppTheme` に集約し、`main.dart` は起動と依存注入に集中します。

## 状態モデル

Stateモデルや集約モデルがListを保持する場合は、コンストラクタで変更不能なListへ変換します。
Repositoryから返すListも変更不能にし、取得元リストの後続変更が画面状態へ波及しないようにします。
Mock RepositoryのListスナップショット化は `mock_repository_snapshot.dart` に集約します。

画面表示用モデルは値オブジェクトとして扱い、同じプロパティ値なら等価になるよう `operator ==` と `hashCode` を実装します。
天気モデルは `WeatherSnapshot` を集約データ、`HourlyForecast` / `DailyForecast` / `WeatherDetail` をサブモデルとして分けます。

## 永続化

IoT操作設定は `IotControlPreferencesRepository` に保存処理を抽象化します。
Chrome版では `SharedPreferencesIotControlPreferencesRepository` が `shared_preferences_web` 経由でブラウザのLocal Storageへ保存します。
保存対象はユーザー操作で変わるIoT設定だけです。センサー値は起動時に `IotSensorRepository` から再取得します。

## デバッグログ

関数先頭の処理ログは `debugPrint()` で出力します。
ログラベルは `[DBG] [Owner] ::function() - 日本語の処理内容` の形式に統一します。
トップレベル関数は `[Global]` をOwnerとして扱います。

## 共通Widget

- `AsyncContentSwitcher`: 取得済み/エラー/読み込み中の表示切り替え
- `AsyncContentStatusConfig`: 非同期画面の読み込み/エラー表示設定
- `StatusContent`: 読み込み/エラー表示
- `ScreenSurface`: 背景装飾とSafeArea適用
- `ResponsiveWrapGrid`: レスポンシブな折り返しグリッド
- `SpacedSliverList`: 固定間隔でセクションを縦に並べるSliverリスト
- `PaddedSliverBox`: 余白付きの単一Sliverボックス
- `ViewModelBuilder`: ViewModelの変更監視
- `HorizontalScrollableList`: 横スクロールリスト

## ディレクトリ構成

```text
mobile_app/lib/
  core/
    app_dependencies.dart
    app_theme.dart
    mock_data/
    repositories/
  models/
  viewmodels/
  views/
    home_page.dart
    widgets/
      common/
      navigation/
      weather/
      notification/
      iot/
      settings/
```
