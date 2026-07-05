import 'package:mobile_app/core/mock_data/mock_iot_sensor_data.dart';
import 'package:mobile_app/core/mock_data/mock_notification_data.dart';
import 'package:mobile_app/core/repositories/in_memory_iot_control_preferences_repository.dart';
import 'package:mobile_app/core/repositories/iot_control_preferences_repository.dart';
import 'package:mobile_app/core/repositories/mock_iot_sensor_repository.dart';
import 'package:mobile_app/core/repositories/mock_notification_repository.dart';
import 'package:mobile_app/core/repositories/mock_weather_repository.dart';
import 'package:mobile_app/models/iot_control_state.dart';
import 'package:mobile_app/models/iot_sensor_reading.dart';
import 'package:mobile_app/models/notification_item.dart';
import 'package:mobile_app/models/weather_snapshot.dart';
import 'package:mobile_app/viewmodels/iot_control_view_model.dart';
import 'package:mobile_app/viewmodels/notification_view_model.dart';
import 'package:mobile_app/viewmodels/weather_view_model.dart';

IotControlViewModel createTestIotControlViewModel({
  List<IotSensorReading> sensorReadings = mockIotSensorReadings,
  IotControlState? initialState,
  IotControlPreferencesRepository? iotControlPreferencesRepository,
}) {
  return IotControlViewModel(
    iotSensorRepository: MockIotSensorRepository(
      sensorReadings: sensorReadings,
    ),
    iotControlPreferencesRepository:
        iotControlPreferencesRepository ??
        InMemoryIotControlPreferencesRepository(),
    initialState: initialState,
  );
}

NotificationViewModel createTestNotificationViewModel({
  List<NotificationItem> notifications = mockNotifications,
}) {
  return NotificationViewModel(
    notificationRepository: MockNotificationRepository(
      notifications: notifications,
    ),
  );
}

Future<NotificationViewModel> createLoadedTestNotificationViewModel({
  List<NotificationItem> notifications = mockNotifications,
}) async {
  final viewModel = createTestNotificationViewModel(
    notifications: notifications,
  );
  await viewModel.loadNotifications();
  return viewModel;
}

WeatherViewModel createTestWeatherViewModel({WeatherSnapshot? weather}) {
  return WeatherViewModel(
    weatherRepository: MockWeatherRepository(weather: weather),
  );
}
