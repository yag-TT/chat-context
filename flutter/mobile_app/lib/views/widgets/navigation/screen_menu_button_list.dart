import 'package:flutter/material.dart';

import '../../../models/app_screen.dart';
import 'screen_destination.dart';
import 'screen_menu_button.dart';

class ScreenMenuButtonList extends StatelessWidget {
  const ScreenMenuButtonList({
    super.key,
    required this.destinations,
    required this.selectedScreen,
    required this.onScreenSelected,
  });

  final List<ScreenDestination> destinations;
  final AppScreen selectedScreen;
  final ValueChanged<AppScreen> onScreenSelected;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [ScreenMenuButtonList] ::build() - 画面を描画します');
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final destination in destinations)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ScreenMenuButton(
                destination: destination,
                selectedScreen: selectedScreen,
                onScreenSelected: onScreenSelected,
              ),
            ),
        ],
      ),
    );
  }
}
