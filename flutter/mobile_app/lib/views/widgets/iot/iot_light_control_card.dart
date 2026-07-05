import 'package:flutter/material.dart';

import 'iot_panel.dart';
import 'iot_panel_header.dart';
import 'light_brightness_slider.dart';

class IotLightControlCard extends StatelessWidget {
  const IotLightControlCard({
    super.key,
    required this.isOn,
    required this.brightness,
    required this.onPowerChanged,
    required this.onBrightnessChanged,
  });

  final bool isOn;
  final double brightness;
  final ValueChanged<bool> onPowerChanged;
  final ValueChanged<double>? onBrightnessChanged;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [IotLightControlCard] ::build() - UIを描画します');
    return IotPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IotPanelHeader(
            icon: Icons.lightbulb_rounded,
            iconColor: Colors.amber,
            title: 'リビングライト',
            subtitle: isOn ? '明るさ ${brightness.round()}%' : 'オフ',
            trailing: Switch(
              value: isOn,
              onChanged: onPowerChanged,
              activeThumbColor: Colors.amber,
            ),
          ),
          const SizedBox(height: 10),
          LightBrightnessSlider(
            value: brightness,
            onChanged: onBrightnessChanged,
          ),
        ],
      ),
    );
  }
}
