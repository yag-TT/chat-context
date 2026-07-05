import 'package:flutter/material.dart';

class WeatherTemperatureDisplay extends StatelessWidget {
  const WeatherTemperatureDisplay({super.key, required this.temperature});

  final int temperature;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [WeatherTemperatureDisplay] ::build() - UIを描画します');
    return Text(
      '$temperature°',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
        color: Colors.white,
        fontSize: 86,
        fontWeight: FontWeight.w200,
        height: 0.96,
      ),
    );
  }
}
