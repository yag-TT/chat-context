import 'package:mobile_app/core/app_dependencies.dart';
import 'package:mobile_app/core/repositories/in_memory_iot_control_preferences_repository.dart';
import 'package:mobile_app/core/repositories/iot_control_preferences_repository.dart';
import 'package:mobile_app/core/repositories/mock_iot_sensor_repository.dart';
import 'package:mobile_app/core/repositories/mock_notification_repository.dart';
import 'package:mobile_app/core/repositories/mock_weather_repository.dart';
import 'package:mobile_app/models/iot_sensor_reading.dart';
import 'package:mobile_app/models/notification_item.dart';
import 'package:mobile_app/models/weather_snapshot.dart';

AppDependencies createTestAppDependencies({
  WeatherSnapshot? weather,
  List<NotificationItem>? notifications,
  List<IotSensorReading>? sensorReadings,
  IotControlPreferencesRepository? iotControlPreferencesRepository,
}) {
  return AppDependencies(
    weatherRepository: MockWeatherRepository(weather: weather),
    notificationRepository: MockNotificationRepository(
      notifications: notifications ?? const [],
    ),
    iotSensorRepository: MockIotSensorRepository(
      sensorReadings: sensorReadings ?? const [],
    ),
    iotControlPreferencesRepository:
        iotControlPreferencesRepository ??
        InMemoryIotControlPreferencesRepository(),
  );
}

WeatherSnapshot createTestWeatherSnapshot({String city = '東京'}) {
  return WeatherSnapshot(
    city: city,
    updatedAtLabel: '12:00 更新',
    temperature: 20,
    condition: '晴れ',
    highTemperature: 24,
    lowTemperature: 16,
    summary: '$city のテスト天気です。',
    hourlyForecasts: const [],
    dailyForecasts: const [],
    details: const [],
  );
}
