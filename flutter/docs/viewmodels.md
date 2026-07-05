# ViewModel設計

全ViewModelは `BaseViewModel` を継承します。
Repositoryから非同期取得するViewModelは `AsyncViewModel` を継承します。

## BaseViewModel

責務:

- dispose済み状態の保持
- ViewModel共通の安全な通知処理
- 複数フィールドをまとめて更新する処理の共通化
- 同値更新時の不要な通知抑止
- dispose後の状態更新抑止
- 二重disposeの無視

`notifyListenersIfActive()` は破棄後の通知を抑止します。
`updateState()` は複数フィールドをまとめて変更し、dispose済みなら状態更新も通知も行いません。
`updateValue()` は値が変わった時だけ通知します。

## AsyncViewModel

責務:

- 読み込み中状態の保持
- エラーメッセージの保持
- 非同期読み込み前後の通知処理
- dispose後に完了した非同期取得結果の破棄
- 古い非同期取得結果による最新状態の上書き防止

非同期取得結果の反映は `runLoadValue()` に集約します。

## HomePageViewModels

`HomePage` で使うViewModel群を束ね、生成と破棄の順序を1箇所に集約します。
Repositoryを使う画面の初期データ取得は `loadInitialData()` から明示的に開始します。
ViewModelのコンストラクタではデータ取得を開始しません。

## HomeViewModel

責務:

- 画面選択
- フローティングメニュー開閉

画面タイトル、説明、アイコン、色などのDestination定義は `screen_destinations.dart` の `defaultScreenDestinations` に置きます。
表示用のDestination型は `screen_destination.dart` に置き、モデル層は画面種別の `AppScreen` だけを扱います。
dispose済みの場合は、メニュー開閉や画面選択による状態更新を行いません。

## WeatherViewModel

責務:

- 天気情報取得
- 読み込み/エラー状態
- 取得済み天気データの保持

## NotificationViewModel

責務:

- 通知一覧取得
- 読み込み/エラー状態
- 選択中通知の管理

通知一覧と選択中通知のまとまりは `NotificationState` に置きます。
通知一覧が0件で取得完了した場合も読み込み中へ戻らないよう、未取得かどうかは `hasLoadedNotifications` で判定します。
通知一覧の取得結果反映は `NotificationState.withLoadedNotifications()` に集約します。

## IotControlViewModel

責務:

- IoT画面上の各デバイス操作状態
- 保存済みIoT操作設定の復元
- センサー表示データの取得
- IoT操作設定の保存
- 操作変更時の `notifyListenersIfActive()`

IoT操作状態のまとまりは `IotControlState` に置きます。
センサー表示データの取得は `IotSensorRepository` に委譲します。
操作設定の読み込みと保存は `IotControlPreferencesRepository` に委譲します。
`loadInitialData()` は保存済み操作設定を復元してからセンサー値を取得します。
操作メソッドで状態が変わった場合は、`_saveControlState()` で保存を非同期に開始します。
保存に失敗しても画面操作を止めず、デバッグログへ失敗内容を出します。
`IotControlState.hasLoadedSensorReadings` は未取得と取得済み0件を区別します。
明るさと設定温度のデフォルト値、最小値、最大値、刻み幅、正規化関数は `iot_control_constraints.dart` に定義します。

## SettingsViewModel

責務:

- 設定画面上の各設定値
- 設定変更時の `notifyListenersIfActive()`

設定値のまとまりは `SettingsState` に置きます。
データ更新間隔のデフォルト値、最小値、最大値、刻み幅は `settings_state.dart` に定義します。
