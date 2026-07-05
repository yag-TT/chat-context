import 'package:flutter/material.dart';

class SpacedSliverList extends StatelessWidget {
  const SpacedSliverList({
    super.key,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.spacing = 12,
    this.bottomSpacing = 0,
  }) : assert(spacing >= 0),
       assert(bottomSpacing >= 0);

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [SpacedSliverList] ::build() - UIを描画します');
    return SliverPadding(
      padding: padding,
      sliver: SliverList.list(children: _spacedChildren),
    );
  }

  List<Widget> get _spacedChildren {
    final spacedChildren = <Widget>[];

    for (var index = 0; index < children.length; index += 1) {
      if (index > 0) {
        spacedChildren.add(SizedBox(height: spacing));
      }
      spacedChildren.add(children[index]);
    }

    if (bottomSpacing > 0) {
      spacedChildren.add(SizedBox(height: bottomSpacing));
    }

    return spacedChildren;
  }
}
