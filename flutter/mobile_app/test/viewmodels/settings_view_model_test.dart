import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/settings_state.dart';
import 'package:mobile_app/viewmodels/settings_view_model.dart';

import '../helpers/change_notifier_counter.dart';

void main() {
  test('updates settings state', () {
    final viewModel = SettingsViewModel();
    addTearDown(viewModel.dispose);

    viewModel
      ..setWeatherAlertEnabled(false)
      ..setDeviceAutomationEnabled(false)
      ..setDarkModePreviewEnabled(true)
      ..setRefreshIntervalMinutes(30);

    expect(viewModel.state.isWeatherAlertEnabled, isFalse);
    expect(viewModel.state.isDeviceAutomationEnabled, isFalse);
    expect(viewModel.state.isDarkModePreviewEnabled, isTrue);
    expect(viewModel.state.refreshIntervalMinutes, 30);
  });

  test('clamps refresh interval', () {
    final viewModel = SettingsViewModel();
    addTearDown(viewModel.dispose);

    viewModel.setRefreshIntervalMinutes(settingsMaxRefreshIntervalMinutes + 1);
    expect(
      viewModel.state.refreshIntervalMinutes,
      settingsMaxRefreshIntervalMinutes,
    );

    viewModel.setRefreshIntervalMinutes(settingsMinRefreshIntervalMinutes - 1);
    expect(
      viewModel.state.refreshIntervalMinutes,
      settingsMinRefreshIntervalMinutes,
    );
  });

  test('does not notify when settings state is unchanged', () {
    final viewModel = SettingsViewModel();
    addTearDown(viewModel.dispose);
    final notifications = ChangeNotifierCounter(viewModel);

    viewModel
      ..setWeatherAlertEnabled(true)
      ..setDeviceAutomationEnabled(true)
      ..setDarkModePreviewEnabled(false)
      ..setRefreshIntervalMinutes(settingsDefaultRefreshIntervalMinutes);

    expect(notifications.count, 0);
  });
}
