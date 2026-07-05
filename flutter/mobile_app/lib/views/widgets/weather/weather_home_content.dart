import 'package:flutter/material.dart';

import '../../../models/weather_snapshot.dart';
import '../common/padded_sliver_box.dart';
import '../common/screen_surface.dart';
import '../common/spaced_sliver_list.dart';
import 'weather_current_section.dart';
import 'weather_daily_forecast_panel.dart';
import 'weather_detail_section.dart';
import 'weather_hourly_forecast_panel.dart';
import 'weather_summary_panel.dart';
import 'weather_styles.dart';

class WeatherHomeContent extends StatelessWidget {
  const WeatherHomeContent({super.key, required this.weather});

  final WeatherSnapshot weather;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [WeatherHomeContent] ::build() - UIを描画します');
    return ScreenSurface(
      decoration: weatherBackgroundDecoration,
      child: CustomScrollView(
        slivers: [
          PaddedSliverBox(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
            child: WeatherCurrentSection(weather: weather),
          ),
          SpacedSliverList(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            bottomSpacing: 96,
            children: [
              WeatherSummaryPanel(summary: weather.summary),
              WeatherHourlyForecastPanel(forecasts: weather.hourlyForecasts),
              WeatherDailyForecastPanel(forecasts: weather.dailyForecasts),
              WeatherDetailSection(details: weather.details),
            ],
          ),
        ],
      ),
    );
  }
}
