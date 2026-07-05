import 'package:flutter/material.dart';

import 'settings_group.dart';
import 'settings_refresh_interval_tile.dart';
import 'settings_switch_tile.dart';

class SettingsDisplayGroup extends StatelessWidget {
  const SettingsDisplayGroup({
    super.key,
    required this.isDarkModePreviewEnabled,
    required this.refreshIntervalMinutes,
    required this.onDarkModePreviewChanged,
    required this.onRefreshIntervalChanged,
  });

  final bool isDarkModePreviewEnabled;
  final int refreshIntervalMinutes;
  final ValueChanged<bool> onDarkModePreviewChanged;
  final ValueChanged<int> onRefreshIntervalChanged;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [SettingsDisplayGroup] ::build() - UIを描画します');
    return SettingsGroup(
      title: '表示',
      children: [
        SettingsRefreshIntervalTile(
          minutes: refreshIntervalMinutes,
          onChanged: onRefreshIntervalChanged,
        ),
        SettingsSwitchTile(
          icon: Icons.dark_mode_outlined,
          title: 'ダークプレビュー',
          subtitle: '夜間向けの配色確認を有効にします',
          value: isDarkModePreviewEnabled,
          onChanged: onDarkModePreviewChanged,
        ),
      ],
    );
  }
}
