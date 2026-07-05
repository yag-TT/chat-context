# 画面設計

## HomePage

`HomePage` は画面単位ViewModelのライフサイクルと初期データ取得を担当します。
親Widgetから `AppDependencies` が差し替わった場合は、保持しているViewModel群を破棄して作り直し、初期データを再取得します。

- `HomeScaffold`: アプリ全体のScaffoldと画面切り替え表示
- `HomeScreenAppBar`: ホーム以外の画面で表示するAppBar
- `HomeScreenBody`: 選択中画面に対応するWidgetの解決
- `NotificationDetailListener`: 通知詳細シートの起動監視
- `HomePageViewModels`: 画面単位ViewModelの生成と破棄

画面種別は `AppScreen` に集約します。
画面メニューのタイトル、説明、アイコン、色は `screen_destinations.dart` の `defaultScreenDestinations` に集約します。
画面メニューのボタンリスト、個別ボタン、開閉ボタンは `ScreenMenuButtonList`、`ScreenMenuButton`、`ScreenMenuToggleButton` に分けます。

## ホーム画面

ホーム画面は `WeatherScreen` が `WeatherViewModel` を監視し、`WeatherScreenContent` が読み込み状態を切り替え、`WeatherHomeContent` が天気表示を描画します。

- `WeatherCurrentSection`: 現在天気のヘッダー
- `WeatherTemperatureDisplay`: 大きな気温表示
- `WeatherConditionSummary`: 天気状態、最高/最低、更新時刻
- `WeatherSummaryPanel`: 概要文パネル
- `WeatherHourlyForecastPanel` / `WeatherHourlyForecastItem`: 時間別予報
- `WeatherDailyForecastPanel` / `WeatherDailyForecastRow`: 日別予報
- `WeatherDailyTemperatureSummary` / `WeatherTemperatureRangeBar`: 日別予報の温度表示
- `WeatherDetailSection` / `WeatherDetailCard`: 天気詳細

横スクロールのリスト構造は `HorizontalScrollableList`、入力デバイス設定は `HorizontalDragScrollBehavior` で共通化します。

## 検索画面

検索画面は `IotControlScreen` が `IotControlViewModel` を監視し、`IotControlContent` が描画します。
`IotControlViewModel` は `HomePage` が保持し、画面を切り替えても操作状態を維持します。
Chrome版ではIoT操作設定をLocal Storageへ保存するため、ブラウザをリロードしても同じオリジン内で設定を引き継ぎます。

IoT操作状態は `IotControlState` にまとめ、`IotControlActions.fromViewModel()` でViewModelの操作メソッドへ接続します。
デバイス操作カード群は `IotDeviceControlSection` に分け、`IotControlContent` は画面全体のスクロール構造を担当します。

- `IotPanel`: IoTカード共通の枠
- `IotPanelHeader`: ヘッダー表示
- `IotLightControlCard`: 照明操作
- `IotClimateControlCard`: 空調操作
- `IotToggleDeviceGrid`: トグルデバイス配置
- `IotStatusSection`: ステータスメトリクス配置
- `IotSensorSection` / `IotSensorChip`: センサー値表示

センサー値の取得口は `IotSensorRepository` に分け、`IotControlViewModel` はRepository経由で初期表示データを読み込みます。
操作設定の保存口は `IotControlPreferencesRepository` に分け、センサー値とは別に扱います。

## 通知画面

通知画面は `NotificationScreen` が `NotificationViewModel` を監視し、`NotificationScreenContent` が読み込み状態を切り替え、`NotificationContent` が通知一覧を描画します。

- `NotificationSummary`: 通知サマリー
- `NotificationCard`: 通知カードの枠
- `NotificationCardLayout`: カード内配置
- `NotificationCardBody`: カード本文
- `SpacedSliverList`: 通知カードの縦リスト

通知カードを押すと、`selectedNotification` が更新され、`NotificationDetailListener` が `NotificationDetailSheet` を表示します。
詳細シートの起動可否は `NotificationDetailLaunchState` が管理します。
シート起動関数は `NotificationDetailSheetLauncher` として差し替え可能です。

通知詳細のドラッグハンドル、ヘッダー、本文、確認ボタンは `notification_sheet_drag_handle.dart`、`notification_detail_header.dart`、`notification_detail_body.dart`、`notification_detail_action.dart` に分けます。

## 設定画面

設定画面は `SettingsScreen` が `SettingsViewModel` を監視し、`SettingsContent` が描画します。
設定画面の状態は `SettingsState` にまとめ、`SettingsActions.fromViewModel()` でViewModelの操作メソッドへ接続します。

- `SettingsHeader`: ヘッダー表示
- `SettingsGroup`: 設定グループ枠
- `SettingsSwitchTile`: ON/OFF設定
- `SettingsRefreshIntervalTile`: 更新間隔設定
- `SettingsNotificationGroup`: 通知設定
- `SettingsDisplayGroup`: 表示設定
