import 'package:flutter/material.dart';

import '../../models/daily_forecast.dart';
import '../../models/hourly_forecast.dart';

const mockHourlyForecasts = [
  HourlyForecast(timeLabel: '今', icon: Icons.wb_sunny_rounded, temperature: 24),
  HourlyForecast(
    timeLabel: '22時',
    icon: Icons.nightlight_round,
    temperature: 23,
  ),
  HourlyForecast(
    timeLabel: '23時',
    icon: Icons.cloud_queue_rounded,
    temperature: 23,
  ),
  HourlyForecast(timeLabel: '0時', icon: Icons.cloud_rounded, temperature: 22),
  HourlyForecast(timeLabel: '1時', icon: Icons.cloud_rounded, temperature: 22),
  HourlyForecast(
    timeLabel: '2時',
    icon: Icons.water_drop_outlined,
    temperature: 21,
  ),
  HourlyForecast(timeLabel: '3時', icon: Icons.cloudy_snowing, temperature: 21),
  HourlyForecast(
    timeLabel: '4時',
    icon: Icons.wb_twilight_rounded,
    temperature: 21,
  ),
];

const mockDailyForecasts = [
  DailyForecast(
    dayLabel: '今日',
    icon: Icons.wb_sunny_rounded,
    condition: '晴れ',
    highTemperature: 28,
    lowTemperature: 20,
  ),
  DailyForecast(
    dayLabel: '土',
    icon: Icons.cloud_queue_rounded,
    condition: 'くもり',
    highTemperature: 27,
    lowTemperature: 21,
  ),
  DailyForecast(
    dayLabel: '日',
    icon: Icons.umbrella_rounded,
    condition: '雨',
    highTemperature: 24,
    lowTemperature: 19,
  ),
  DailyForecast(
    dayLabel: '月',
    icon: Icons.thunderstorm_rounded,
    condition: '雷雨',
    highTemperature: 25,
    lowTemperature: 20,
  ),
  DailyForecast(
    dayLabel: '火',
    icon: Icons.wb_sunny_rounded,
    condition: '晴れ',
    highTemperature: 30,
    lowTemperature: 22,
  ),
];
