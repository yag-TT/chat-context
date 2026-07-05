import '../core/app_dependencies.dart';
import 'base_view_model.dart';
import 'home_view_model.dart';
import 'iot_control_view_model.dart';
import 'notification_view_model.dart';
import 'settings_view_model.dart';
import 'weather_view_model.dart';
import 'package:flutter/foundation.dart';

/// HomePage配下で使うViewModelをまとめて保持します。
///
/// 画面ごとのViewModel生成、初期読み込み、破棄順序を1箇所に集約し、
/// HomePage本体がライフサイクル制御に集中できるようにします。
class HomePageViewModels {
  HomePageViewModels({required AppDependencies dependencies})
    : home = HomeViewModel(),
      weather = WeatherViewModel(
        weatherRepository: dependencies.weatherRepository,
      ),
      iotControl = IotControlViewModel(
        iotSensorRepository: dependencies.iotSensorRepository,
        iotControlPreferencesRepository:
            dependencies.iotControlPreferencesRepository,
      ),
      notifications = NotificationViewModel(
        notificationRepository: dependencies.notificationRepository,
      ),
      settings = SettingsViewModel();

  final HomeViewModel home;
  final WeatherViewModel weather;
  final IotControlViewModel iotControl;
  final NotificationViewModel notifications;
  final SettingsViewModel settings;
  bool _isDisposed = false;

  bool get isDisposed {
    debugPrint('[DBG] [HomePageViewModels] ::isDisposed() - 破棄済みか確認します');
    return _isDisposed;
  }

  Future<void> loadInitialData() async {
    debugPrint(
      '[DBG] [HomePageViewModels] ::loadInitialData() - 初期表示データを読み込みます',
    );
    if (_isDisposed) {
      return;
    }

    // 画面ごとの初期データは独立しているため並列で読み込みます。
    await Future.wait([
      weather.loadWeather(),
      iotControl.loadInitialData(),
      notifications.loadNotifications(),
    ]);
  }

  void dispose() {
    debugPrint('[DBG] [HomePageViewModels] ::dispose() - 保持しているリソースを破棄します');
    if (_isDisposed) {
      return;
    }

    for (final viewModel in _disposeOrder) {
      viewModel.dispose();
    }
    _isDisposed = true;
  }

  List<BaseViewModel> get _disposeOrder {
    // 子画面側のViewModelから先に破棄し、最後にナビゲーション状態を破棄します。
    return [settings, notifications, iotControl, weather, home];
  }
}
