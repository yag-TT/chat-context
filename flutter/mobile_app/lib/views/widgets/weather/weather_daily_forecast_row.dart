import 'package:flutter/material.dart';

import '../../../models/daily_forecast.dart';
import 'weather_daily_temperature_summary.dart';

class WeatherDailyForecastRow extends StatelessWidget {
  const WeatherDailyForecastRow({super.key, required this.forecast});

  final DailyForecast forecast;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [WeatherDailyForecastRow] ::build() - UIを描画します');
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 42,
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              forecast.dayLabel,
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Icon(forecast.icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              forecast.condition,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.78),
              ),
            ),
          ),
          WeatherDailyTemperatureSummary(
            lowTemperature: forecast.lowTemperature,
            highTemperature: forecast.highTemperature,
          ),
        ],
      ),
    );
  }
}
