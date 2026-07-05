import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/repositories/in_memory_iot_control_preferences_repository.dart';
import 'package:mobile_app/core/mock_data/mock_iot_sensor_data.dart';
import 'package:mobile_app/models/fan_mode.dart';
import 'package:mobile_app/models/iot_control_constraints.dart';
import 'package:mobile_app/models/iot_control_state.dart';

import '../helpers/change_notifier_counter.dart';
import '../helpers/test_view_models.dart';

void main() {
  test('updates IoT control state', () async {
    final viewModel = createTestIotControlViewModel();
    addTearDown(viewModel.dispose);

    await viewModel.loadSensorReadings();

    viewModel
      ..setLivingLightOn(false)
      ..setTargetTemperature(22.5)
      ..setFanMode(FanMode.quiet);

    expect(viewModel.state.isLivingLightOn, isFalse);
    expect(viewModel.state.targetTemperature, 22.5);
    expect(viewModel.state.fanMode, FanMode.quiet);
    expect(viewModel.state.sensorReadings, mockIotSensorReadings);
    expect(viewModel.state.hasLoadedSensorReadings, isTrue);
  });

  test('loadSensorReadings marks empty results as loaded', () async {
    final viewModel = createTestIotControlViewModel(sensorReadings: []);
    addTearDown(viewModel.dispose);

    await viewModel.loadSensorReadings();

    expect(viewModel.state.sensorReadings, isEmpty);
    expect(viewModel.state.hasLoadedSensorReadings, isTrue);
  });

  test('loads injected IoT sensor readings', () async {
    final viewModel = createTestIotControlViewModel(
      sensorReadings: mockIotSensorReadings.take(1).toList(),
    );
    addTearDown(viewModel.dispose);

    await viewModel.loadSensorReadings();

    expect(
      viewModel.state.sensorReadings,
      mockIotSensorReadings.take(1).toList(),
    );
  });

  test('does not notify when IoT state is unchanged', () {
    final viewModel = createTestIotControlViewModel();
    addTearDown(viewModel.dispose);
    final notifications = ChangeNotifierCounter(viewModel);

    viewModel
      ..setHomeOnline(true)
      ..setLivingLightOn(true)
      ..setEntranceLocked(true)
      ..setAirPurifierOn(false)
      ..setLightBrightness(iotDefaultLightBrightness)
      ..setTargetTemperature(iotDefaultTargetTemperature)
      ..setFanMode(FanMode.auto);

    expect(notifications.count, 0);
  });

  test('clamps numeric IoT control values', () {
    final viewModel = createTestIotControlViewModel();
    addTearDown(viewModel.dispose);

    viewModel
      ..setLightBrightness(iotMaxLightBrightness + 1)
      ..setTargetTemperature(iotMaxTargetTemperature + 1);

    expect(viewModel.state.lightBrightness, iotMaxLightBrightness);
    expect(viewModel.state.targetTemperature, iotMaxTargetTemperature);

    viewModel
      ..setLightBrightness(iotMinLightBrightness - 1)
      ..setTargetTemperature(iotMinTargetTemperature - 1);

    expect(viewModel.state.lightBrightness, iotMinLightBrightness);
    expect(viewModel.state.targetTemperature, iotMinTargetTemperature);
  });

  test('keeps existing operation state when loading sensor readings', () async {
    final viewModel = createTestIotControlViewModel(
      initialState: IotControlState(isLivingLightOn: false),
    );
    addTearDown(viewModel.dispose);

    await viewModel.loadSensorReadings();

    expect(viewModel.state.isLivingLightOn, isFalse);
    expect(viewModel.state.sensorReadings, mockIotSensorReadings);
  });

  test('loads saved IoT operation settings with sensor readings', () async {
    final preferencesRepository = InMemoryIotControlPreferencesRepository(
      initialState: IotControlState(
        isHomeOnline: false,
        isLivingLightOn: false,
        isEntranceLocked: false,
        isAirPurifierOn: true,
        lightBrightness: 72,
        targetTemperature: 23.5,
        fanMode: FanMode.quiet,
        sensorReadings: mockIotSensorReadings.take(1).toList(),
        hasLoadedSensorReadings: true,
      ),
    );
    final viewModel = createTestIotControlViewModel(
      iotControlPreferencesRepository: preferencesRepository,
    );
    addTearDown(viewModel.dispose);

    await viewModel.loadInitialData();

    expect(viewModel.state.isHomeOnline, isFalse);
    expect(viewModel.state.isLivingLightOn, isFalse);
    expect(viewModel.state.isEntranceLocked, isFalse);
    expect(viewModel.state.isAirPurifierOn, isTrue);
    expect(viewModel.state.lightBrightness, 72);
    expect(viewModel.state.targetTemperature, 23.5);
    expect(viewModel.state.fanMode, FanMode.quiet);
    expect(viewModel.state.sensorReadings, mockIotSensorReadings);
    expect(viewModel.state.hasLoadedSensorReadings, isTrue);
  });

  test('saves changed IoT operation settings', () async {
    final preferencesRepository = InMemoryIotControlPreferencesRepository();
    final viewModel = createTestIotControlViewModel(
      iotControlPreferencesRepository: preferencesRepository,
    );
    addTearDown(viewModel.dispose);

    viewModel
      ..setHomeOnline(false)
      ..setLivingLightOn(false)
      ..setEntranceLocked(false)
      ..setAirPurifierOn(true)
      ..setLightBrightness(64)
      ..setTargetTemperature(21.5)
      ..setFanMode(FanMode.strong);
    await Future<void>.delayed(Duration.zero);

    final savedState = await preferencesRepository.loadState();

    expect(savedState, isNotNull);
    expect(savedState!.isHomeOnline, isFalse);
    expect(savedState.isLivingLightOn, isFalse);
    expect(savedState.isEntranceLocked, isFalse);
    expect(savedState.isAirPurifierOn, isTrue);
    expect(savedState.lightBrightness, 64);
    expect(savedState.targetTemperature, 21.5);
    expect(savedState.fanMode, FanMode.strong);
    expect(savedState.sensorReadings, isEmpty);
    expect(savedState.hasLoadedSensorReadings, isFalse);
  });
}
