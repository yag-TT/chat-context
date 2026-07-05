import 'package:flutter/material.dart';

import '../../../models/hourly_forecast.dart';

class WeatherHourlyForecastItem extends StatelessWidget {
  const WeatherHourlyForecastItem({super.key, required this.forecast});

  final HourlyForecast forecast;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [WeatherHourlyForecastItem] ::build() - UIを描画します');
    return SizedBox(
      width: 62,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            forecast.timeLabel,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(forecast.icon, color: Colors.white, size: 28),
          Text(
            '${forecast.temperature}°',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
