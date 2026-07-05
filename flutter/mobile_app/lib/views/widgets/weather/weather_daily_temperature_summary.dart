import 'package:flutter/material.dart';

import 'weather_temperature_range_bar.dart';

class WeatherDailyTemperatureSummary extends StatelessWidget {
  const WeatherDailyTemperatureSummary({
    super.key,
    required this.lowTemperature,
    required this.highTemperature,
  });

  final int lowTemperature;
  final int highTemperature;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [WeatherDailyTemperatureSummary] ::build() - UIを描画します');
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$lowTemperature°',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.62),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        const WeatherTemperatureRangeBar(),
        const SizedBox(width: 8),
        Text(
          '$highTemperature°',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
