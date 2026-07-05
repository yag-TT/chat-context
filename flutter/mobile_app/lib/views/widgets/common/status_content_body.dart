import 'package:flutter/material.dart';

import 'status_content_style.dart';

class StatusContentBody extends StatelessWidget {
  const StatusContentBody({
    super.key,
    required this.icon,
    required this.title,
    required this.style,
    required this.actionLabel,
    required this.onActionPressed,
  });

  final IconData icon;
  final String title;
  final StatusContentStyle style;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [StatusContentBody] ::build() - UIを描画します');
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: style.iconColor, size: 48),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: style.titleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (actionLabel != null && onActionPressed != null) ...[
            const SizedBox(height: 20),
            FilledButton(onPressed: onActionPressed, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
