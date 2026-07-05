import 'package:flutter/material.dart';

import 'horizontal_drag_scroll_behavior.dart';

class HorizontalScrollableList extends StatefulWidget {
  const HorizontalScrollableList({
    super.key,
    required this.height,
    required this.itemCount,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.padding = EdgeInsets.zero,
  });

  final double height;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final EdgeInsetsGeometry padding;

  @override
  // ignore: no_logic_in_create_state
  State<HorizontalScrollableList> createState() {
    debugPrint(
      '[DBG] [HorizontalScrollableList] ::createState() - Stateを生成します',
    );
    return _HorizontalScrollableListState();
  }
}

class _HorizontalScrollableListState extends State<HorizontalScrollableList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    debugPrint(
      '[DBG] [_HorizontalScrollableListState] ::initState() - 初期化処理を開始します',
    );
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    debugPrint(
      '[DBG] [_HorizontalScrollableListState] ::dispose() - 保持しているリソースを破棄します',
    );
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [_HorizontalScrollableListState] ::build() - UIを描画します');
    return SizedBox(
      height: widget.height,
      child: ScrollConfiguration(
        behavior: const HorizontalDragScrollBehavior(),
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          trackVisibility: true,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: widget.padding,
            itemCount: widget.itemCount,
            separatorBuilder: widget.separatorBuilder,
            itemBuilder: widget.itemBuilder,
          ),
        ),
      ),
    );
  }
}
