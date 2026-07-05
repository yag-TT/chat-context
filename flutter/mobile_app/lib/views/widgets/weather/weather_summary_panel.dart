import 'package:flutter/material.dart';

import 'weather_glass_panel.dart';

class WeatherSummaryPanel extends StatelessWidget {
  const WeatherSummaryPanel({super.key, required this.summary});

  final String summary;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [WeatherSummaryPanel] ::build() - UIを描画します');
    return WeatherGlassPanel(
      child: Text(
        summary,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white.withValues(alpha: 0.92),
          height: 1.55,
        ),
      ),
    );
  }
}
