# テストと実行

## テスト方針

現在のテストは以下を確認します。

- Repositoryがモックデータを返すこと
- ViewModelへRepositoryを注入してデータを保持できること
- BaseViewModelがdispose後の通知を抑止すること
- AsyncViewModelが読み込み状態とエラー状態を更新すること
- dispose済みViewModelへ同期/非同期の状態更新を反映しないこと
- 並行した非同期読み込みでは最新の結果だけを反映すること
- HomePageViewModelsが画面単位ViewModelをまとめて破棄すること
- HomePageViewModelsが初期データ取得を開始すること
- HomeViewModelが注入された `AppScreen` 一覧で画面選択できること
- 通知ViewModelが通知一覧と選択状態を保持すること
- IoT ViewModelが操作状態とRepository取得データを保持すること
- IoT ViewModelが保存済み操作設定を復元すること
- IoT ViewModelが操作変更時に操作設定を保存すること
- Stateモデルや集約モデルが保持するListを外部から変更できないこと
- 表示モデルが同じ値なら等価として扱えること
- 設定ViewModelが設定値を更新すること
- 画面切り替え、通知詳細表示がWidget上で動くこと

## テスト補助

```text
mobile_app/test/helpers/
  change_notifier_counter.dart
  test_app_dependencies.dart
  test_view_models.dart
  widget_test_app.dart
```

- `pumpWidgetInApp()`: アプリテーマ付きの `MaterialApp` でWidgetを描画
- `ChangeNotifierCounter`: ViewModelの通知回数検証
- `createTestAppDependencies()`: テスト用Repository群を持つ `AppDependencies` 生成
- `createTestWeatherSnapshot()`: テスト用天気データ生成
- `createTest*ViewModel()`: Repository注入済みViewModel生成
- `createLoadedTestNotificationViewModel()`: 通知読み込み済みViewModel生成

## 実行・検証コマンド

```powershell
cd D:\work\Test\Flutter\mvvm\mobile_app
dart format lib test
flutter analyze
flutter test
flutter build web
flutter run -d chrome
```

`flutter run -d chrome` 実行中の操作:

```text
r: Hot reload
R: Hot restart
q: Quit
```

コード変更をChrome実行中に反映する場合は、実行中のターミナルで `r` を押します。
アプリ状態を作り直したい場合は `R`、終了したい場合は `q` を押します。

## Chrome版の保存データ確認

Chrome版のIoT操作設定は、ブラウザのLocal Storageに保存されます。
DevToolsで確認する場合は、`Application` または `アプリケーション` タブの `Storage > Local storage` を開きます。
タブが見当たらない場合はDevTools上部の `>>`、または `More tools` から表示します。

IoT操作設定だけを削除する場合は、DevToolsのConsoleで以下を実行します。

```javascript
Object.keys(localStorage)
  .filter((key) => key.includes('iot_control.'))
  .forEach((key) => localStorage.removeItem(key));
```
