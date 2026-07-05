import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/mock_data/mock_weather_details.dart';
import 'package:mobile_app/core/mock_data/mock_weather_forecasts.dart';
import 'package:mobile_app/models/weather_snapshot.dart';

void main() {
  test('forecast and detail lists are immutable after construction', () {
    final hourlyForecasts = List.of(mockHourlyForecasts);
    final dailyForecasts = List.of(mockDailyForecasts);
    final details = List.of(mockWeatherDetails);

    final snapshot = WeatherSnapshot(
      city: '東京',
      updatedAtLabel: '21:00 更新',
      temperature: 24,
      condition: '晴れ',
      highTemperature: 28,
      lowTemperature: 20,
      summary: 'テスト用の天気です。',
      hourlyForecasts: hourlyForecasts,
      dailyForecasts: dailyForecasts,
      details: details,
    );

    hourlyForecasts.clear();
    dailyForecasts.clear();
    details.clear();

    expect(snapshot.hourlyForecasts, mockHourlyForecasts);
    expect(snapshot.dailyForecasts, mockDailyForecasts);
    expect(snapshot.details, mockWeatherDetails);
    expect(() => snapshot.hourlyForecasts.clear(), throwsUnsupportedError);
    expect(() => snapshot.dailyForecasts.clear(), throwsUnsupportedError);
    expect(() => snapshot.details.clear(), throwsUnsupportedError);
  });

  test('snapshots with same values are equal', () {
    final first = WeatherSnapshot(
      city: '東京',
      updatedAtLabel: '21:00 更新',
      temperature: 24,
      condition: '晴れ',
      highTemperature: 28,
      lowTemperature: 20,
      summary: 'テスト用の天気です。',
      hourlyForecasts: mockHourlyForecasts,
      dailyForecasts: mockDailyForecasts,
      details: mockWeatherDetails,
    );
    final second = WeatherSnapshot(
      city: '東京',
      updatedAtLabel: '21:00 更新',
      temperature: 24,
      condition: '晴れ',
      highTemperature: 28,
      lowTemperature: 20,
      summary: 'テスト用の天気です。',
      hourlyForecasts: List.of(mockHourlyForecasts),
      dailyForecasts: List.of(mockDailyForecasts),
      details: List.of(mockWeatherDetails),
    );

    expect(first, second);
    expect(first.hashCode, second.hashCode);
  });
}
