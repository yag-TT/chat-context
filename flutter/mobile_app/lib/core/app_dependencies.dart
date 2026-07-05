import 'repositories/in_memory_iot_control_preferences_repository.dart';
import 'repositories/iot_control_preferences_repository.dart';
import 'repositories/iot_sensor_repository.dart';
import 'repositories/mock_iot_sensor_repository.dart';
import 'repositories/mock_notification_repository.dart';
import 'repositories/mock_weather_repository.dart';
import 'repositories/notification_repository.dart';
import 'repositories/shared_preferences_iot_control_preferences_repository.dart';
import 'repositories/weather_repository.dart';
import 'package:flutter/foundation.dart';

/// アプリ全体で使うRepository群をまとめた依存コンテナです。
///
/// Widgetツリーの上位から渡すことで、ViewModelがMock実装を直接生成せず、
/// Repositoryインターフェースだけに依存できるようにしています。
class AppDependencies {
  const AppDependencies({
    required this.weatherRepository,
    required this.notificationRepository,
    required this.iotSensorRepository,
    required this.iotControlPreferencesRepository,
  });

  /// ローカル確認で使うRepository一式を作ります。
  AppDependencies.local()
    : weatherRepository = MockWeatherRepository(),
      notificationRepository = MockNotificationRepository(),
      iotSensorRepository = MockIotSensorRepository(),
      iotControlPreferencesRepository =
          SharedPreferencesIotControlPreferencesRepository();

  /// Widgetテストで使うモックRepository一式を作ります。
  AppDependencies.mock()
    : weatherRepository = MockWeatherRepository(),
      notificationRepository = MockNotificationRepository(),
      iotSensorRepository = MockIotSensorRepository(),
      iotControlPreferencesRepository =
          InMemoryIotControlPreferencesRepository();

  final WeatherRepository weatherRepository;
  final NotificationRepository notificationRepository;
  final IotSensorRepository iotSensorRepository;
  final IotControlPreferencesRepository iotControlPreferencesRepository;

  @override
  bool operator ==(Object other) {
    debugPrint('[DBG] [AppDependencies] ::operator==() - 同じ値か比較します');
    return identical(this, other) ||
        other is AppDependencies &&
            other.weatherRepository == weatherRepository &&
            other.notificationRepository == notificationRepository &&
            other.iotSensorRepository == iotSensorRepository &&
            other.iotControlPreferencesRepository ==
                iotControlPreferencesRepository;
  }

  @override
  int get hashCode {
    debugPrint('[DBG] [AppDependencies] ::hashCode() - ハッシュ値を計算します');
    return Object.hash(
      weatherRepository,
      notificationRepository,
      iotSensorRepository,
      iotControlPreferencesRepository,
    );
  }
}
