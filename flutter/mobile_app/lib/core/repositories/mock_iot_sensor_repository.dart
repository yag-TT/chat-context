import '../mock_data/mock_iot_sensor_data.dart';
import '../../models/iot_sensor_reading.dart';
import 'iot_sensor_repository.dart';
import 'mock_repository_snapshot.dart';
import 'package:flutter/foundation.dart';

class MockIotSensorRepository implements IotSensorRepository {
  MockIotSensorRepository({
    List<IotSensorReading> sensorReadings = mockIotSensorReadings,
  }) : sensorReadings = snapshotRepositoryList(sensorReadings);

  final List<IotSensorReading> sensorReadings;

  @override
  Future<List<IotSensorReading>> fetchSensorReadings() async {
    debugPrint(
      '[DBG] [MockIotSensorRepository] ::fetchSensorReadings() - Repositoryからモックデータを取得します',
    );
    return sensorReadings;
  }
}
