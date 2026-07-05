import 'package:flutter/material.dart';

class WeatherTemperatureRangeBar extends StatelessWidget {
  const WeatherTemperatureRangeBar({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [WeatherTemperatureRangeBar] ::build() - UIを描画します');
    return SizedBox(
      width: 64,
      height: 5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: const LinearGradient(
            colors: [Color(0xFF9BD9FF), Color(0xFFFFD166)],
          ),
        ),
      ),
    );
  }
}
