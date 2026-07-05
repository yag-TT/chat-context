import 'package:flutter/material.dart';

import '../../../models/app_screen.dart';
import '../../../viewmodels/home_page_view_models.dart';
import '../iot/iot_control_screen.dart';
import '../notification/notification_screen.dart';
import '../settings/settings_screen.dart';
import '../weather/weather_screen.dart';

/// AppScreenの選択値を、対応する画面Widgetへ変換します。
class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({
    super.key,
    required this.selectedScreen,
    required this.viewModels,
  });

  final AppScreen selectedScreen;
  final HomePageViewModels viewModels;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [HomeScreenBody] ::build() - 画面を描画します');
    return switch (selectedScreen) {
      AppScreen.home => WeatherScreen(viewModel: viewModels.weather),
      AppScreen.search => IotControlScreen(viewModel: viewModels.iotControl),
      AppScreen.notifications => NotificationScreen(
        viewModel: viewModels.notifications,
      ),
      AppScreen.settings => SettingsScreen(viewModel: viewModels.settings),
    };
  }
}
