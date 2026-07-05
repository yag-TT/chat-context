import 'package:flutter/material.dart';

import 'screen_destination.dart';

class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeScreenAppBar({super.key, required this.destination});

  final ScreenDestination destination;

  @override
  Size get preferredSize {
    debugPrint(
      '[DBG] [HomeScreenAppBar] ::preferredSize() - AppBarの推奨サイズを返します',
    );
    return const Size.fromHeight(kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [HomeScreenAppBar] ::build() - 画面を描画します');
    return AppBar(
      backgroundColor: destination.color.withValues(alpha: 0.16),
      title: Text(destination.title),
    );
  }
}
