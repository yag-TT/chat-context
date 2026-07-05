import 'package:flutter/material.dart';

class HourlyForecast {
  const HourlyForecast({
    required this.timeLabel,
    required this.icon,
    required this.temperature,
  });

  final String timeLabel;
  final IconData icon;
  final int temperature;

  @override
  bool operator ==(Object other) {
    debugPrint('[DBG] [HourlyForecast] ::operator==() - 同じ値か比較します');
    return identical(this, other) ||
        other is HourlyForecast &&
            other.timeLabel == timeLabel &&
            other.icon == icon &&
            other.temperature == temperature;
  }

  @override
  int get hashCode {
    debugPrint('[DBG] [HourlyForecast] ::hashCode() - ハッシュ値を計算します');
    return Object.hash(timeLabel, icon, temperature);
  }
}
