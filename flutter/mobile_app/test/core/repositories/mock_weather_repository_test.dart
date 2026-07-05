import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/mock_data/mock_weather_data.dart';
import 'package:mobile_app/core/repositories/mock_weather_repository.dart';
import 'package:mobile_app/models/weather_snapshot.dart';

void main() {
  test('fetchCurrentWeather returns mock weather for Tokyo', () async {
    final repository = MockWeatherRepository();

    final weather = await repository.fetchCurrentWeather();

    expect(weather.city, '東京');
    expect(weather.temperature, 24);
    expect(weather.hourlyForecasts, isNotEmpty);
    expect(weather.dailyForecasts, hasLength(5));
    expect(weather.details, hasLength(4));
  });

  test('fetchCurrentWeather returns injected weather', () async {
    final injectedWeather = WeatherSnapshot(
      city: '大阪',
      updatedAtLabel: '10:00 更新',
      temperature: 18,
      condition: '雨',
      highTemperature: 21,
      lowTemperature: 16,
      summary: 'テスト用の天気です。',
      hourlyForecasts: [],
      dailyForecasts: [],
      details: [],
    );
    final repository = MockWeatherRepository(weather: injectedWeather);

    final weather = await repository.fetchCurrentWeather();

    expect(weather, same(injectedWeather));
    expect(weather, isNot(same(mockWeatherSnapshot)));
  });
}
