import 'package:flutter/material.dart';

import '../../../models/settings_state.dart';
import 'settings_styles.dart';

class SettingsRefreshIntervalTile extends StatelessWidget {
  const SettingsRefreshIntervalTile({
    super.key,
    required this.minutes,
    required this.onChanged,
  });

  final int minutes;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [SettingsRefreshIntervalTile] ::build() - UIを描画します');
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sync, color: settingsAccentColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'データ更新間隔',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$minutes分',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: settingsStrongAccentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Slider(
            value: minutes.toDouble(),
            min: settingsMinRefreshIntervalMinutes.toDouble(),
            max: settingsMaxRefreshIntervalMinutes.toDouble(),
            divisions: settingsRefreshIntervalDivisions,
            label: '$minutes分',
            activeColor: settingsStrongAccentColor,
            onChanged: (value) => onChanged(value.round()),
          ),
        ],
      ),
    );
  }
}
