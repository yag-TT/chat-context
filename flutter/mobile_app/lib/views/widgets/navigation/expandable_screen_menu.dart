import 'package:flutter/material.dart';

import '../../../models/app_screen.dart';
import 'screen_destination.dart';
import 'screen_menu_button_list.dart';
import 'screen_menu_toggle_button.dart';

class ExpandableScreenMenu extends StatelessWidget {
  const ExpandableScreenMenu({
    super.key,
    required this.destinations,
    required this.selectedScreen,
    required this.isMenuOpen,
    required this.onMenuToggled,
    required this.onScreenSelected,
  });

  final List<ScreenDestination> destinations;
  final AppScreen selectedScreen;
  final bool isMenuOpen;
  final VoidCallback onMenuToggled;
  final ValueChanged<AppScreen> onScreenSelected;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [ExpandableScreenMenu] ::build() - 画面を描画します');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1,
                child: child,
              ),
            );
          },
          child: isMenuOpen
              ? ScreenMenuButtonList(
                  destinations: destinations,
                  selectedScreen: selectedScreen,
                  onScreenSelected: onScreenSelected,
                )
              : const SizedBox.shrink(),
        ),
        ScreenMenuToggleButton(
          isMenuOpen: isMenuOpen,
          onPressed: onMenuToggled,
        ),
      ],
    );
  }
}
