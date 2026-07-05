import 'package:flutter/material.dart';

import 'iot_panel.dart';
import 'iot_panel_header.dart';

class IotToggleDeviceCard extends StatelessWidget {
  const IotToggleDeviceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [IotToggleDeviceCard] ::build() - UIを描画します');
    return IotPanel(
      child: IotPanelHeader(
        icon: icon,
        iconColor: color,
        title: title,
        subtitle: subtitle,
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: color,
        ),
      ),
    );
  }
}
