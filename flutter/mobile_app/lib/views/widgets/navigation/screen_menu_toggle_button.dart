import 'package:flutter/material.dart';

class ScreenMenuToggleButton extends StatelessWidget {
  const ScreenMenuToggleButton({
    super.key,
    required this.isMenuOpen,
    required this.onPressed,
  });

  final bool isMenuOpen;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [ScreenMenuToggleButton] ::build() - 画面を描画します');
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: '画面選択',
      child: Icon(isMenuOpen ? Icons.close : Icons.apps),
    );
  }
}
