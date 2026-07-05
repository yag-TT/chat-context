import 'package:flutter/material.dart';

class NotificationDetailAction extends StatelessWidget {
  const NotificationDetailAction({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [NotificationDetailAction] ::build() - UIを描画します');
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.check_rounded),
        label: const Text('確認しました'),
      ),
    );
  }
}
