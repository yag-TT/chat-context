import 'package:flutter/material.dart';

import '../../../models/app_screen.dart';
import 'screen_destination.dart';

class ScreenMenuButton extends StatelessWidget {
  const ScreenMenuButton({
    super.key,
    required this.destination,
    required this.selectedScreen,
    required this.onScreenSelected,
  });

  final ScreenDestination destination;
  final AppScreen selectedScreen;
  final ValueChanged<AppScreen> onScreenSelected;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [ScreenMenuButton] ::build() - 画面を描画します');
    final isSelected = selectedScreen == destination.screen;

    return FloatingActionButton.extended(
      heroTag: 'screen_button_${destination.screen.name}',
      onPressed: () => onScreenSelected(destination.screen),
      backgroundColor: isSelected ? destination.color : null,
      foregroundColor: isSelected ? Colors.white : null,
      icon: Icon(destination.icon),
      label: Text(destination.title),
    );
  }
}
