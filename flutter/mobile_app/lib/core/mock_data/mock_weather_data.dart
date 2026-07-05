import '../../models/weather_snapshot.dart';
import 'mock_weather_details.dart';
import 'mock_weather_forecasts.dart';

final mockWeatherSnapshot = WeatherSnapshot(
  city: '東京',
  updatedAtLabel: '21:00 更新',
  temperature: 24,
  condition: '晴れ時々くもり',
  highTemperature: 28,
  lowTemperature: 20,
  summary: '今夜は雲が広がりますが、雨の心配は少なめです。明日の午後は日差しが戻り、少し蒸し暑く感じられます。',
  hourlyForecasts: mockHourlyForecasts,
  dailyForecasts: mockDailyForecasts,
  details: mockWeatherDetails,
);
