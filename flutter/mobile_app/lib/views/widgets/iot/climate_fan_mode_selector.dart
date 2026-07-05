import 'package:flutter/material.dart';

import '../../../models/fan_mode.dart';

class ClimateFanModeSelector extends StatelessWidget {
  const ClimateFanModeSelector({
    super.key,
    required this.selectedMode,
    required this.onChanged,
  });

  final FanMode selectedMode;
  final ValueChanged<FanMode> onChanged;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [ClimateFanModeSelector] ::build() - UIを描画します');
    return SegmentedButton<FanMode>(
      segments: [
        for (final mode in FanMode.values)
          ButtonSegment(
            value: mode,
            icon: Icon(mode.iconData),
            label: Text(mode.label),
          ),
      ],
      selected: {selectedMode},
      onSelectionChanged: (values) {
        onChanged(values.first);
      },
    );
  }
}

extension _FanModePresentation on FanMode {
  String get label {
    return switch (this) {
      FanMode.auto => '自動',
      FanMode.quiet => '静音',
      FanMode.strong => '強風',
    };
  }

  IconData get iconData {
    return switch (this) {
      FanMode.auto => Icons.auto_mode_rounded,
      FanMode.quiet => Icons.nightlight_round,
      FanMode.strong => Icons.air_rounded,
    };
  }
}
