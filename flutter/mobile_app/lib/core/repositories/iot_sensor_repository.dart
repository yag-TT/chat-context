import '../../models/iot_sensor_reading.dart';

abstract class IotSensorRepository {
  Future<List<IotSensorReading>> fetchSensorReadings();
}
