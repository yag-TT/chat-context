import 'package:flutter/material.dart';

class DailyForecast {
  const DailyForecast({
    required this.dayLabel,
    required this.icon,
    required this.condition,
    required this.highTemperature,
    required this.lowTemperature,
  });

  final String dayLabel;
  final IconData icon;
  final String condition;
  final int highTemperature;
  final int lowTemperature;

  @override
  bool operator ==(Object other) {
    debugPrint('[DBG] [DailyForecast] ::operator==() - 同じ値か比較します');
    return identical(this, other) ||
        other is DailyForecast &&
            other.dayLabel == dayLabel &&
            other.icon == icon &&
            other.condition == condition &&
            other.highTemperature == highTemperature &&
            other.lowTemperature == lowTemperature;
  }

  @override
  int get hashCode {
    debugPrint('[DBG] [DailyForecast] ::hashCode() - ハッシュ値を計算します');
    return Object.hash(
      dayLabel,
      icon,
      condition,
      highTemperature,
      lowTemperature,
    );
  }
}
