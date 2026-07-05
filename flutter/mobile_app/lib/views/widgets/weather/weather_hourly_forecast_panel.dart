import 'package:flutter/material.dart';

import '../../../models/hourly_forecast.dart';
import '../common/horizontal_scrollable_list.dart';
import 'weather_glass_panel.dart';
import 'weather_hourly_forecast_item.dart';

class WeatherHourlyForecastPanel extends StatelessWidget {
  const WeatherHourlyForecastPanel({super.key, required this.forecasts});

  final List<HourlyForecast> forecasts;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [WeatherHourlyForecastPanel] ::build() - UIを描画します');
    return WeatherGlassPanel(
      title: '時間ごとの予報',
      child: HorizontalScrollableList(
        height: 118,
        padding: const EdgeInsets.only(bottom: 14),
        itemCount: forecasts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return WeatherHourlyForecastItem(forecast: forecasts[index]);
        },
      ),
    );
  }
}
