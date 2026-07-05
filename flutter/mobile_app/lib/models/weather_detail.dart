import 'package:flutter/material.dart';

class WeatherDetail {
  const WeatherDetail({
    required this.label,
    required this.value,
    required this.icon,
    required this.description,
  });

  final String label;
  final String value;
  final IconData icon;
  final String description;

  @override
  bool operator ==(Object other) {
    debugPrint('[DBG] [WeatherDetail] ::operator==() - 同じ値か比較します');
    return identical(this, other) ||
        other is WeatherDetail &&
            other.label == label &&
            other.value == value &&
            other.icon == icon &&
            other.description == description;
  }

  @override
  int get hashCode {
    debugPrint('[DBG] [WeatherDetail] ::hashCode() - ハッシュ値を計算します');
    return Object.hash(label, value, icon, description);
  }
}
