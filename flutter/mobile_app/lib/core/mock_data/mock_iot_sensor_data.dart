import 'package:flutter/material.dart';

import '../../models/iot_sensor_reading.dart';

const mockIotSensorReadings = [
  IotSensorReading(
    icon: Icons.water_drop_rounded,
    label: '湿度',
    value: '48%',
    color: Colors.lightBlue,
  ),
  IotSensorReading(
    icon: Icons.co2_rounded,
    label: 'CO2',
    value: '612 ppm',
    color: Colors.green,
  ),
  IotSensorReading(
    icon: Icons.door_sliding_rounded,
    label: '窓',
    value: '閉',
    color: Colors.blueGrey,
  ),
];
