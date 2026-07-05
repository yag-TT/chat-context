import 'package:flutter/material.dart';

class IotPanelHeaderIcon extends StatelessWidget {
  const IotPanelHeaderIcon({
    super.key,
    required this.icon,
    required this.iconColor,
  });

  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [IotPanelHeaderIcon] ::build() - UIを描画します');
    return SizedBox(
      width: 42,
      height: 42,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
    );
  }
}
