import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/daily_forecast.dart';
import 'package:mobile_app/models/hourly_forecast.dart';
import 'package:mobile_app/models/weather_detail.dart';

void main() {
  test('hourly forecasts with same values are equal', () {
    const first = HourlyForecast(
      timeLabel: '今',
      icon: Icons.wb_sunny_rounded,
      temperature: 24,
    );
    const second = HourlyForecast(
      timeLabel: '今',
      icon: Icons.wb_sunny_rounded,
      temperature: 24,
    );

    expect(first, second);
    expect(first.hashCode, second.hashCode);
  });

  test('daily forecasts with same values are equal', () {
    const first = DailyForecast(
      dayLabel: '今日',
      icon: Icons.cloud_queue_rounded,
      condition: 'くもり',
      highTemperature: 27,
      lowTemperature: 21,
    );
    const second = DailyForecast(
      dayLabel: '今日',
      icon: Icons.cloud_queue_rounded,
      condition: 'くもり',
      highTemperature: 27,
      lowTemperature: 21,
    );

    expect(first, second);
    expect(first.hashCode, second.hashCode);
  });

  test('weather details with same values are equal', () {
    const first = WeatherDetail(
      label: '湿度',
      value: '68%',
      icon: Icons.water_drop_rounded,
      description: '夜にかけてやや高めです。',
    );
    const second = WeatherDetail(
      label: '湿度',
      value: '68%',
      icon: Icons.water_drop_rounded,
      description: '夜にかけてやや高めです。',
    );

    expect(first, second);
    expect(first.hashCode, second.hashCode);
  });
}
