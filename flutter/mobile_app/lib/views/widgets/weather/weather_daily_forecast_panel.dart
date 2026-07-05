import 'package:flutter/material.dart';

import '../../../models/daily_forecast.dart';
import 'weather_daily_forecast_row.dart';
import 'weather_glass_panel.dart';

class WeatherDailyForecastPanel extends StatelessWidget {
  const WeatherDailyForecastPanel({super.key, required this.forecasts});

  final List<DailyForecast> forecasts;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [WeatherDailyForecastPanel] ::build() - UIを描画します');
    return WeatherGlassPanel(
      title: '5日間の予報',
      child: Column(
        children: [
          for (var index = 0; index < forecasts.length; index++) ...[
            WeatherDailyForecastRow(forecast: forecasts[index]),
            if (index != forecasts.length - 1)
              Divider(color: Colors.white.withValues(alpha: 0.18), height: 18),
          ],
        ],
      ),
    );
  }
}
