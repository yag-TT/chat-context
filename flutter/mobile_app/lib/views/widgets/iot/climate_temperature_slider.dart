import 'package:flutter/material.dart';

import '../../../models/iot_control_constraints.dart';

class ClimateTemperatureSlider extends StatelessWidget {
  const ClimateTemperatureSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [ClimateTemperatureSlider] ::build() - UIを描画します');
    return Slider(
      value: value,
      min: iotMinTargetTemperature,
      max: iotMaxTargetTemperature,
      divisions: iotTargetTemperatureDivisions,
      label: '${value.toStringAsFixed(1)}°',
      onChanged: onChanged,
    );
  }
}
