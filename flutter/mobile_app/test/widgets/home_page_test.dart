import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/app_dependencies.dart';
import 'package:mobile_app/core/repositories/in_memory_iot_control_preferences_repository.dart';
import 'package:mobile_app/core/repositories/mock_iot_sensor_repository.dart';
import 'package:mobile_app/core/repositories/mock_notification_repository.dart';
import 'package:mobile_app/core/repositories/mock_weather_repository.dart';
import 'package:mobile_app/views/home_page.dart';

import '../helpers/test_app_dependencies.dart';
import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('recreates view models when dependencies change', (tester) async {
    await pumpWidgetInApp(
      tester,
      HomePage(
        dependencies: createTestAppDependencies(
          weather: createTestWeatherSnapshot(city: '東京'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('東京'), findsOneWidget);

    await pumpWidgetInApp(
      tester,
      HomePage(
        dependencies: createTestAppDependencies(
          weather: createTestWeatherSnapshot(city: '札幌'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('札幌'), findsOneWidget);
    expect(find.text('東京'), findsNothing);
  });

  testWidgets('keeps view models when equivalent dependencies are provided', (
    tester,
  ) async {
    final weatherRepository = MockWeatherRepository(
      weather: createTestWeatherSnapshot(city: '東京'),
    );
    final notificationRepository = MockNotificationRepository();
    final iotSensorRepository = MockIotSensorRepository();
    final iotControlPreferencesRepository =
        InMemoryIotControlPreferencesRepository();

    await pumpWidgetInApp(
      tester,
      HomePage(
        dependencies: AppDependencies(
          weatherRepository: weatherRepository,
          notificationRepository: notificationRepository,
          iotSensorRepository: iotSensorRepository,
          iotControlPreferencesRepository: iotControlPreferencesRepository,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.apps));
    await tester.pumpAndSettle();
    await tester.tap(find.text('検索'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch).at(1));
    await tester.pumpAndSettle();

    expect(find.text('オフ'), findsOneWidget);

    await pumpWidgetInApp(
      tester,
      HomePage(
        dependencies: AppDependencies(
          weatherRepository: weatherRepository,
          notificationRepository: notificationRepository,
          iotSensorRepository: iotSensorRepository,
          iotControlPreferencesRepository: iotControlPreferencesRepository,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('オフ'), findsOneWidget);
  });
}
