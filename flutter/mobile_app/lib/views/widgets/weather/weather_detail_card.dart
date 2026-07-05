import 'package:flutter/material.dart';

import '../../../models/weather_detail.dart';
import 'weather_glass_panel.dart';

class WeatherDetailCard extends StatelessWidget {
  const WeatherDetailCard({super.key, required this.detail});

  final WeatherDetail detail;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [WeatherDetailCard] ::build() - UIを描画します');
    final textTheme = Theme.of(context).textTheme;

    return WeatherGlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                detail.icon,
                color: Colors.white.withValues(alpha: 0.72),
                size: 18,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  detail.label,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            detail.value,
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            detail.description,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
