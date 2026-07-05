import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/app_dependencies.dart';
import 'package:mobile_app/core/repositories/in_memory_iot_control_preferences_repository.dart';
import 'package:mobile_app/core/repositories/mock_iot_sensor_repository.dart';
import 'package:mobile_app/core/repositories/mock_notification_repository.dart';
import 'package:mobile_app/core/repositories/mock_weather_repository.dart';

void main() {
  test('mock dependencies provide mock repositories', () {
    final dependencies = AppDependencies.mock();

    expect(dependencies.weatherRepository, isA<MockWeatherRepository>());
    expect(
      dependencies.notificationRepository,
      isA<MockNotificationRepository>(),
    );
    expect(dependencies.iotSensorRepository, isA<MockIotSensorRepository>());
    expect(
      dependencies.iotControlPreferencesRepository,
      isA<InMemoryIotControlPreferencesRepository>(),
    );
  });

  test('dependencies with same repository instances are equal', () {
    final weatherRepository = MockWeatherRepository();
    final notificationRepository = MockNotificationRepository();
    final iotSensorRepository = MockIotSensorRepository();
    final iotControlPreferencesRepository =
        InMemoryIotControlPreferencesRepository();

    final first = AppDependencies(
      weatherRepository: weatherRepository,
      notificationRepository: notificationRepository,
      iotSensorRepository: iotSensorRepository,
      iotControlPreferencesRepository: iotControlPreferencesRepository,
    );
    final second = AppDependencies(
      weatherRepository: weatherRepository,
      notificationRepository: notificationRepository,
      iotSensorRepository: iotSensorRepository,
      iotControlPreferencesRepository: iotControlPreferencesRepository,
    );

    expect(first, second);
    expect(first.hashCode, second.hashCode);
  });

  test('dependencies with different repository instances are not equal', () {
    final first = AppDependencies.mock();
    final second = AppDependencies.mock();

    expect(first, isNot(second));
  });
}
