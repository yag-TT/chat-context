import 'package:flutter/material.dart';

import '../../../models/iot_control_constraints.dart';

class LightBrightnessSlider extends StatelessWidget {
  const LightBrightnessSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [LightBrightnessSlider] ::build() - UIを描画します');
    return Slider(
      value: value,
      min: iotMinLightBrightness,
      max: iotMaxLightBrightness,
      divisions: iotLightBrightnessDivisions,
      label: '${value.round()}%',
      onChanged: onChanged,
    );
  }
}
