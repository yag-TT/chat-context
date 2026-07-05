import 'package:flutter/material.dart';

class PaddedSliverBox extends StatelessWidget {
  const PaddedSliverBox({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [PaddedSliverBox] ::build() - UIを描画します');
    return SliverPadding(
      padding: padding,
      sliver: SliverToBoxAdapter(child: child),
    );
  }
}
