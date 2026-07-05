import 'package:flutter/material.dart';

import '../../../viewmodels/settings_view_model.dart';

class SettingsActions {
  const SettingsActions({
    required this.onWeatherAlertChanged,
    required this.onDeviceAutomationChanged,
    required this.onDarkModePreviewChanged,
    required this.onRefreshIntervalChanged,
  });

  factory SettingsActions.fromViewModel(SettingsViewModel viewModel) {
    return SettingsActions(
      onWeatherAlertChanged: viewModel.setWeatherAlertEnabled,
      onDeviceAutomationChanged: viewModel.setDeviceAutomationEnabled,
      onDarkModePreviewChanged: viewModel.setDarkModePreviewEnabled,
      onRefreshIntervalChanged: viewModel.setRefreshIntervalMinutes,
    );
  }

  final ValueChanged<bool> onWeatherAlertChanged;
  final ValueChanged<bool> onDeviceAutomationChanged;
  final ValueChanged<bool> onDarkModePreviewChanged;
  final ValueChanged<int> onRefreshIntervalChanged;
}
