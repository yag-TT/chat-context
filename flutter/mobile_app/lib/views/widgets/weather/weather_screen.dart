import 'package:flutter/material.dart';

import '../../../viewmodels/weather_view_model.dart';
import '../common/view_model_builder.dart';
import 'weather_screen_content.dart';

/// WeatherViewModelを監視し、天気画面の描画用Widgetへ状態を渡します。
class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key, required this.viewModel});

  final WeatherViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [WeatherScreen] ::build() - 画面を描画します');
    return ViewModelBuilder(
      viewModel: viewModel,
      builder: (context, viewModel) {
        return WeatherScreenContent(
          weather: viewModel.weather,
          errorMessage: viewModel.errorMessage,
          onRetryPressed: viewModel.loadWeather,
        );
      },
    );
  }
}
