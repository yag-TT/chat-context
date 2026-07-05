import 'package:flutter/material.dart';

import '../../../models/settings_state.dart';
import '../common/screen_surface.dart';
import 'settings_actions.dart';
import 'settings_display_group.dart';
import 'settings_header.dart';
import 'settings_notification_group.dart';
import 'settings_styles.dart';

/// 設定画面のレイアウトと設定グループの並びを担当します。
class SettingsContent extends StatelessWidget {
  const SettingsContent({
    super.key,
    required this.state,
    required this.actions,
  });

  final SettingsState state;
  final SettingsActions actions;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [SettingsContent] ::build() - UIを描画します');
    return ScreenSurface(
      decoration: settingsBackgroundDecoration,
      child: ListView(
        padding: settingsContentPadding,
        children: [
          const SettingsHeader(),
          const SizedBox(height: settingsHeaderToGroupSpacing),
          SettingsNotificationGroup(
            isWeatherAlertEnabled: state.isWeatherAlertEnabled,
            isDeviceAutomationEnabled: state.isDeviceAutomationEnabled,
            onWeatherAlertChanged: actions.onWeatherAlertChanged,
            onDeviceAutomationChanged: actions.onDeviceAutomationChanged,
          ),
          const SizedBox(height: settingsGroupSpacing),
          SettingsDisplayGroup(
            isDarkModePreviewEnabled: state.isDarkModePreviewEnabled,
            refreshIntervalMinutes: state.refreshIntervalMinutes,
            onDarkModePreviewChanged: actions.onDarkModePreviewChanged,
            onRefreshIntervalChanged: actions.onRefreshIntervalChanged,
          ),
        ],
      ),
    );
  }
}
