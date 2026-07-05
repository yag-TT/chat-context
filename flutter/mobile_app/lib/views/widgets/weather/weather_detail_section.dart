import 'package:flutter/material.dart';

import '../../../models/weather_detail.dart';
import '../common/responsive_wrap_grid.dart';
import 'weather_detail_card.dart';

class WeatherDetailSection extends StatelessWidget {
  const WeatherDetailSection({super.key, required this.details});

  final List<WeatherDetail> details;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [WeatherDetailSection] ::build() - UIを描画します');
    return ResponsiveWrapGrid(
      children: [
        for (final detail in details) WeatherDetailCard(detail: detail),
      ],
    );
  }
}
