import '../mock_data/mock_weather_data.dart';
import '../../models/weather_snapshot.dart';
import 'weather_repository.dart';
import 'package:flutter/foundation.dart';

class MockWeatherRepository implements WeatherRepository {
  MockWeatherRepository({WeatherSnapshot? weather})
    : weather = weather ?? mockWeatherSnapshot;

  final WeatherSnapshot weather;

  @override
  Future<WeatherSnapshot> fetchCurrentWeather() async {
    debugPrint(
      '[DBG] [MockWeatherRepository] ::fetchCurrentWeather() - Repositoryからモックデータを取得します',
    );
    return weather;
  }
}
