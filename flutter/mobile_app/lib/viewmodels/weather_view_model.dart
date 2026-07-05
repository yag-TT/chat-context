import '../core/repositories/weather_repository.dart';
import '../models/weather_snapshot.dart';
import 'async_view_model.dart';
import 'package:flutter/foundation.dart';

/// ホーム画面に表示する天気情報の取得状態を管理します。
class WeatherViewModel extends AsyncViewModel {
  WeatherViewModel({required WeatherRepository weatherRepository})
    : _weatherRepository = weatherRepository;

  final WeatherRepository _weatherRepository;
  WeatherSnapshot? _weather;

  WeatherSnapshot? get weather {
    debugPrint('[DBG] [WeatherViewModel] ::weather() - 天気状態を参照します');
    return _weather;
  }

  Future<void> loadWeather() async {
    debugPrint('[DBG] [WeatherViewModel] ::loadWeather() - 天気情報を読み込みます');
    await runLoadValue(
      errorMessage: '天気情報を取得できませんでした。',
      load: _weatherRepository.fetchCurrentWeather,
      onData: (weather) {
        _weather = weather;
      },
    );
  }
}
