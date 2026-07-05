import 'package:flutter/material.dart';

class ScreenSurface extends StatelessWidget {
  const ScreenSurface({
    super.key,
    required this.decoration,
    required this.child,
    this.useSafeArea = true,
  });

  final Decoration decoration;
  final Widget child;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [ScreenSurface] ::build() - 画面を描画します');
    final content = useSafeArea ? SafeArea(child: child) : child;

    return DecoratedBox(decoration: decoration, child: content);
  }
}
