import 'package:flutter/material.dart';

import 'settings_group.dart';
import 'settings_switch_tile.dart';

class SettingsNotificationGroup extends StatelessWidget {
  const SettingsNotificationGroup({
    super.key,
    required this.isWeatherAlertEnabled,
    required this.isDeviceAutomationEnabled,
    required this.onWeatherAlertChanged,
    required this.onDeviceAutomationChanged,
  });

  final bool isWeatherAlertEnabled;
  final bool isDeviceAutomationEnabled;
  final ValueChanged<bool> onWeatherAlertChanged;
  final ValueChanged<bool> onDeviceAutomationChanged;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [SettingsNotificationGroup] ::build() - UIを描画します');
    return SettingsGroup(
      title: '通知設定',
      children: [
        SettingsSwitchTile(
          icon: Icons.thunderstorm_outlined,
          title: '天気アラート',
          subtitle: '雨雲や気温変化をホーム画面と通知に反映します',
          value: isWeatherAlertEnabled,
          onChanged: onWeatherAlertChanged,
        ),
        SettingsSwitchTile(
          icon: Icons.auto_mode,
          title: 'IoT自動制御',
          subtitle: '在宅状態に合わせて照明と空調の候補を表示します',
          value: isDeviceAutomationEnabled,
          onChanged: onDeviceAutomationChanged,
        ),
      ],
    );
  }
}
