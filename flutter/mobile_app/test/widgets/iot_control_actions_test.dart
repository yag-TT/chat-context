import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/repositories/in_memory_iot_control_preferences_repository.dart';
import 'package:mobile_app/core/repositories/mock_iot_sensor_repository.dart';
import 'package:mobile_app/views/widgets/iot/iot_control_actions.dart';
import 'package:mobile_app/viewmodels/iot_control_view_model.dart';

void main() {
  test('fromViewModel wires callbacks to the IoT view model', () {
    final viewModel = IotControlViewModel(
      iotSensorRepository: MockIotSensorRepository(),
      iotControlPreferencesRepository:
          InMemoryIotControlPreferencesRepository(),
    );
    addTearDown(viewModel.dispose);

    final actions = IotControlActions.fromViewModel(viewModel);

    actions
      ..onHomeOnlineChanged(false)
      ..onLivingLightChanged(false)
      ..onEntranceLockedChanged(false);

    expect(viewModel.state.isHomeOnline, isFalse);
    expect(viewModel.state.isLivingLightOn, isFalse);
    expect(viewModel.state.isEntranceLocked, isFalse);
  });
}
