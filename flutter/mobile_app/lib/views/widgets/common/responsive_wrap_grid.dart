import 'package:flutter/material.dart';

class ResponsiveWrapGrid extends StatelessWidget {
  const ResponsiveWrapGrid({
    super.key,
    required this.children,
    this.breakpoint = 560,
    this.columnCount = 2,
    this.spacing = 12,
    this.runSpacing = 12,
  }) : assert(columnCount > 0),
       assert(breakpoint >= 0),
       assert(spacing >= 0),
       assert(runSpacing >= 0);

  final List<Widget> children;
  final double breakpoint;
  final int columnCount;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [ResponsiveWrapGrid] ::build() - UIを描画します');
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveColumnCount = constraints.maxWidth >= breakpoint
            ? columnCount
            : 1;
        final totalSpacing = spacing * (effectiveColumnCount - 1);
        final itemWidth =
            (constraints.maxWidth - totalSpacing) / effectiveColumnCount;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}
