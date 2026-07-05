import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/mock_data/mock_iot_sensor_data.dart';
import 'package:mobile_app/models/fan_mode.dart';
import 'package:mobile_app/models/iot_control_constraints.dart';
import 'package:mobile_app/models/iot_control_state.dart';

void main() {
  test('copyWith updates selected IoT state fields', () {
    final state = IotControlState().copyWith(
      isLivingLightOn: false,
      targetTemperature: 22.5,
      fanMode: FanMode.quiet,
      sensorReadings: mockIotSensorReadings,
      hasLoadedSensorReadings: true,
    );

    expect(state.isHomeOnline, isTrue);
    expect(state.isLivingLightOn, isFalse);
    expect(state.targetTemperature, 22.5);
    expect(state.fanMode, FanMode.quiet);
    expect(state.sensorReadings, mockIotSensorReadings);
    expect(state.hasLoadedSensorReadings, isTrue);
  });

  test('states with same values are equal', () {
    expect(IotControlState(), IotControlState());
  });

  test('states with same sensor reading values are equal', () {
    final first = IotControlState().copyWith(
      sensorReadings: mockIotSensorReadings,
      hasLoadedSensorReadings: true,
    );
    final second = IotControlState().copyWith(
      sensorReadings: List.of(mockIotSensorReadings),
      hasLoadedSensorReadings: true,
    );

    expect(first, second);
  });

  test('sensor readings are immutable after construction', () {
    final source = List.of(mockIotSensorReadings);
    final state = IotControlState(sensorReadings: source);

    source.clear();

    expect(state.sensorReadings, mockIotSensorReadings);
    expect(() => state.sensorReadings.clear(), throwsUnsupportedError);
  });

  test('withLoadedSensorReadings marks sensor readings as loaded', () {
    final state = IotControlState().withLoadedSensorReadings(
      mockIotSensorReadings,
    );

    expect(state.sensorReadings, mockIotSensorReadings);
    expect(state.hasLoadedSensorReadings, isTrue);
  });

  test(
    'IoT control constraints normalize numeric values to supported ranges',
    () {
      expect(
        normalizeLightBrightness(iotMaxLightBrightness + 1),
        iotMaxLightBrightness,
      );
      expect(
        normalizeLightBrightness(iotMinLightBrightness - 1),
        iotMinLightBrightness,
      );
      expect(
        normalizeTargetTemperature(iotMaxTargetTemperature + 1),
        iotMaxTargetTemperature,
      );
      expect(
        normalizeTargetTemperature(iotMinTargetTemperature - 1),
        iotMinTargetTemperature,
      );
    },
  );

  test('constructor normalizes numeric control values', () {
    final highState = IotControlState(
      lightBrightness: iotMaxLightBrightness + 1,
      targetTemperature: iotMaxTargetTemperature + 1,
    );
    final lowState = IotControlState(
      lightBrightness: iotMinLightBrightness - 1,
      targetTemperature: iotMinTargetTemperature - 1,
    );

    expect(highState.lightBrightness, iotMaxLightBrightness);
    expect(highState.targetTemperature, iotMaxTargetTemperature);
    expect(lowState.lightBrightness, iotMinLightBrightness);
    expect(lowState.targetTemperature, iotMinTargetTemperature);
  });
}
