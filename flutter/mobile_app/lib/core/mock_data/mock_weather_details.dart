import 'package:flutter/material.dart';

import '../../models/weather_detail.dart';

const mockWeatherDetails = [
  WeatherDetail(
    label: '体感温度',
    value: '26°',
    icon: Icons.thermostat_rounded,
    description: '湿度が高く、実際より少し暑く感じます。',
  ),
  WeatherDetail(
    label: '湿度',
    value: '68%',
    icon: Icons.water_drop_rounded,
    description: '夜にかけてやや高めです。',
  ),
  WeatherDetail(
    label: '風',
    value: '南東 3 m/s',
    icon: Icons.air_rounded,
    description: '穏やかな風が吹いています。',
  ),
  WeatherDetail(
    label: '降水確率',
    value: '15%',
    icon: Icons.umbrella_rounded,
    description: '傘なしでも過ごしやすい見込みです。',
  ),
];
