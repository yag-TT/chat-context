import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/mock_data/mock_iot_sensor_data.dart';
import 'package:mobile_app/core/repositories/mock_iot_sensor_repository.dart';
import 'package:mobile_app/models/iot_sensor_reading.dart';

void main() {
  test('fetchSensorReadings returns mock IoT sensor readings', () async {
    final repository = MockIotSensorRepository();

    final sensorReadings = await repository.fetchSensorReadings();

    expect(sensorReadings, mockIotSensorReadings);
    expect(sensorReadings, isNot(same(mockIotSensorReadings)));
  });

  test('fetchSensorReadings returns injected sensor readings', () async {
    const injectedReadings = [
      IotSensorReading(
        icon: Icons.thermostat_rounded,
        label: '室温',
        value: '24度',
        color: Colors.orange,
      ),
    ];
    final repository = MockIotSensorRepository(
      sensorReadings: injectedReadings,
    );

    final sensorReadings = await repository.fetchSensorReadings();

    expect(sensorReadings, injectedReadings);
    expect(sensorReadings, isNot(same(injectedReadings)));
  });

  test('fetchSensorReadings returns an unmodifiable list', () async {
    final repository = MockIotSensorRepository();

    final sensorReadings = await repository.fetchSensorReadings();

    expect(
      () => sensorReadings.add(
        const IotSensorReading(
          icon: Icons.add,
          label: '追加',
          value: '1',
          color: Colors.red,
        ),
      ),
      throwsUnsupportedError,
    );
  });

  test('constructor snapshots injected sensor readings', () async {
    final injectedReadings = [
      const IotSensorReading(
        icon: Icons.thermostat_rounded,
        label: '室温',
        value: '24度',
        color: Colors.orange,
      ),
    ];
    final repository = MockIotSensorRepository(
      sensorReadings: injectedReadings,
    );

    injectedReadings.add(
      const IotSensorReading(
        icon: Icons.add,
        label: '追加',
        value: '1',
        color: Colors.red,
      ),
    );

    final sensorReadings = await repository.fetchSensorReadings();

    expect(sensorReadings, hasLength(1));
    expect(sensorReadings.first.label, '室温');
  });
}
