import 'package:flutter/material.dart';

class WeatherConditionSummary extends StatelessWidget {
  const WeatherConditionSummary({
    super.key,
    required this.condition,
    required this.highTemperature,
    required this.lowTemperature,
    required this.updatedAtLabel,
  });

  final String condition;
  final int highTemperature;
  final int lowTemperature;
  final String updatedAtLabel;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [WeatherConditionSummary] ::build() - UIを描画します');
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          condition,
          textAlign: TextAlign.center,
          style: textTheme.titleMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.86),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '最高:$highTemperature°  最低:$lowTemperature°',
          textAlign: TextAlign.center,
          style: textTheme.titleSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.82),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          updatedAtLabel,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.68),
          ),
        ),
      ],
    );
  }
}
