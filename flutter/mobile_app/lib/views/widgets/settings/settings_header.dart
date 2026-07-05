import 'package:flutter/material.dart';

import 'settings_styles.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [SettingsHeader] ::build() - UIを描画します');
    return Row(
      children: [
        Container(
          width: settingsHeaderIconSize,
          height: settingsHeaderIconSize,
          decoration: BoxDecoration(
            color: settingsAccentColor,
            borderRadius: BorderRadius.circular(settingsHeaderIconRadius),
          ),
          child: const Icon(Icons.settings_outlined, color: Colors.white),
        ),
        const SizedBox(width: settingsHeaderTextSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '設定',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: settingsTitleColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: settingsHeaderTitleSpacing),
              Text(
                '通知、IoT連携、表示の動作を調整します。',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: settingsSubtitleColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
