import '../../models/weather_snapshot.dart';

abstract class WeatherRepository {
  Future<WeatherSnapshot> fetchCurrentWeather();
}
