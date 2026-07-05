import 'package:flutter/material.dart';

class IotSensorReading {
  const IotSensorReading({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  bool operator ==(Object other) {
    debugPrint('[DBG] [IotSensorReading] ::operator==() - 同じ値か比較します');
    return identical(this, other) ||
        other is IotSensorReading &&
            other.icon == icon &&
            other.label == label &&
            other.value == value &&
            other.color == color;
  }

  @override
  int get hashCode {
    debugPrint('[DBG] [IotSensorReading] ::hashCode() - ハッシュ値を計算します');
    return Object.hash(icon, label, value, color);
  }
}
