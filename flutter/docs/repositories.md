# Repository設計

## AppDependencies

`AppDependencies` はアプリで使うRepository実装をまとめます。
同じRepositoryインスタンス群を持つ `AppDependencies` は等価として扱い、親Widgetの再構築時に不要なViewModel再生成を避けます。

Chrome実行時は `AppDependencies.local()` が以下の実装を提供します。

- `MockWeatherRepository`
- `MockNotificationRepository`
- `MockIotSensorRepository`
- `SharedPreferencesIotControlPreferencesRepository`

Widgetテストやモック確認では `AppDependencies.mock()` が以下の実装を提供します。

- `MockWeatherRepository`
- `MockNotificationRepository`
- `MockIotSensorRepository`
- `InMemoryIotControlPreferencesRepository`

モックデータの定義は `core/mock_data` に置き、Repositoryはデフォルトではその定数を返します。
テストや別パターン確認では、Mock Repositoryのコンストラクタへ任意データを渡して差し替えられます。
Listを受け取るMock Repositoryは `snapshotRepositoryList()` で変更不能なListへコピーします。

API実装へ差し替える場合は、各Repositoryインターフェースを実装したクラスを作成し、`MyApp` へ渡す `AppDependencies` を変更します。

## WeatherRepository

```dart
abstract class WeatherRepository {
  Future<WeatherSnapshot> fetchCurrentWeather();
}
```

現在の実装:

- `MockWeatherRepository`

`WeatherViewModel` はこのインターフェースをコンストラクタで受け取ります。

## NotificationRepository

```dart
abstract class NotificationRepository {
  Future<List<NotificationItem>> fetchNotifications();
}
```

現在の実装:

- `MockNotificationRepository`

`NotificationViewModel` はこのインターフェースをコンストラクタで受け取ります。
`MockNotificationRepository` は通知一覧を変更不能な `List` として返し、取得側からRepository内部のリストを変更できないようにします。

## IotSensorRepository

```dart
abstract class IotSensorRepository {
  Future<List<IotSensorReading>> fetchSensorReadings();
}
```

現在の実装:

- `MockIotSensorRepository`

`IotControlViewModel` はこのインターフェースをコンストラクタで受け取ります。
`MockIotSensorRepository` はセンサー値一覧を変更不能な `List` として返し、取得側からRepository内部のリストを変更できないようにします。

## IotControlPreferencesRepository

```dart
abstract class IotControlPreferencesRepository {
  Future<IotControlState?> loadState();
  Future<void> saveState(IotControlState state);
}
```

現在の実装:

- `SharedPreferencesIotControlPreferencesRepository`
- `InMemoryIotControlPreferencesRepository`

`IotControlViewModel` はこのインターフェースをコンストラクタで受け取ります。
`SharedPreferencesIotControlPreferencesRepository` はChrome版のIoT操作設定をブラウザのLocal Storageへ保存します。
`InMemoryIotControlPreferencesRepository` はテスト用で、保存対象の操作設定だけをメモリ上に保持します。

保存対象:

- ホーム接続状態
- リビングライトON/OFF
- 玄関ロック状態
- 空気清浄機ON/OFF
- 照明の明るさ
- 目標温度
- 送風モード

センサー値と `hasLoadedSensorReadings` は保存対象にせず、起動時に `IotSensorRepository` から取得します。
