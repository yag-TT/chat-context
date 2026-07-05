import 'package:flutter/material.dart';

import 'iot_styles.dart';

class IotPanel extends StatelessWidget {
  const IotPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [IotPanel] ::build() - UIを描画します');
    return DecoratedBox(
      decoration: iotPanelDecoration,
      child: Padding(padding: padding, child: child),
    );
  }
}
