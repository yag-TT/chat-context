import 'package:flutter/material.dart';

import 'iot_panel_header_icon.dart';
import 'iot_panel_header_text.dart';

class IotPanelHeader extends StatelessWidget {
  const IotPanelHeader({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [IotPanelHeader] ::build() - UIを描画します');
    return Row(
      children: [
        IotPanelHeaderIcon(icon: icon, iconColor: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: IotPanelHeaderText(title: title, subtitle: subtitle),
        ),
        const SizedBox(width: 10),
        trailing,
      ],
    );
  }
}
