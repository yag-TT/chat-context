import 'package:flutter/foundation.dart';

import 'daily_forecast.dart';
import 'hourly_forecast.dart';
import 'weather_detail.dart';

/// ホーム画面に表示する天気情報一式です。
///
/// 予報や詳細カードのリストは生成時に固定化し、Repositoryやテスト側の
/// 元リスト変更が画面状態へ影響しないようにします。
class WeatherSnapshot {
  WeatherSnapshot({
    required this.city,
    required this.updatedAtLabel,
    required this.temperature,
    required this.condition,
    required this.highTemperature,
    required this.lowTemperature,
    required this.summary,
    required List<HourlyForecast> hourlyForecasts,
    required List<DailyForecast> dailyForecasts,
    required List<WeatherDetail> details,
  }) : hourlyForecasts = List.unmodifiable(hourlyForecasts),
       dailyForecasts = List.unmodifiable(dailyForecasts),
       details = List.unmodifiable(details);

  final String city;
  final String updatedAtLabel;
  final int temperature;
  final String condition;
  final int highTemperature;
  final int lowTemperature;
  final String summary;
  final List<HourlyForecast> hourlyForecasts;
  final List<DailyForecast> dailyForecasts;
  final List<WeatherDetail> details;

  @override
  bool operator ==(Object other) {
    debugPrint('[DBG] [WeatherSnapshot] ::operator==() - 同じ値か比較します');
    return identical(this, other) ||
        other is WeatherSnapshot &&
            other.city == city &&
            other.updatedAtLabel == updatedAtLabel &&
            other.temperature == temperature &&
            other.condition == condition &&
            other.highTemperature == highTemperature &&
            other.lowTemperature == lowTemperature &&
            other.summary == summary &&
            listEquals(other.hourlyForecasts, hourlyForecasts) &&
            listEquals(other.dailyForecasts, dailyForecasts) &&
            listEquals(other.details, details);
  }

  @override
  int get hashCode {
    debugPrint('[DBG] [WeatherSnapshot] ::hashCode() - ハッシュ値を計算します');
    return Object.hash(
      city,
      updatedAtLabel,
      temperature,
      condition,
      highTemperature,
      lowTemperature,
      summary,
      Object.hashAll(hourlyForecasts),
      Object.hashAll(dailyForecasts),
      Object.hashAll(details),
    );
  }
}
