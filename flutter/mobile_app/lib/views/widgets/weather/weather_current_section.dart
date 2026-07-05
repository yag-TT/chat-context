import 'package:flutter/material.dart';

import '../../../models/weather_snapshot.dart';
import 'weather_condition_summary.dart';
import 'weather_temperature_display.dart';

class WeatherCurrentSection extends StatelessWidget {
  const WeatherCurrentSection({super.key, required this.weather});

  final WeatherSnapshot weather;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [WeatherCurrentSection] ::build() - UIを描画します');
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          weather.city,
          textAlign: TextAlign.center,
          style: textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        WeatherTemperatureDisplay(temperature: weather.temperature),
        const SizedBox(height: 8),
        WeatherConditionSummary(
          condition: weather.condition,
          highTemperature: weather.highTemperature,
          lowTemperature: weather.lowTemperature,
          updatedAtLabel: weather.updatedAtLabel,
        ),
      ],
    );
  }
}
