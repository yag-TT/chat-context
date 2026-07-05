import 'package:flutter/material.dart';

import '../../../models/notification_item.dart';
import 'notification_icon.dart';

class NotificationDetailHeader extends StatelessWidget {
  const NotificationDetailHeader({
    super.key,
    required this.notification,
    required this.onClosePressed,
  });

  final NotificationItem notification;
  final VoidCallback onClosePressed;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [NotificationDetailHeader] ::build() - UIを描画します');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NotificationIcon(notification: notification),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.category,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: notification.color,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                notification.receivedAtLabel,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.black.withValues(alpha: 0.48),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onClosePressed,
          icon: const Icon(Icons.close_rounded),
          tooltip: '閉じる',
        ),
      ],
    );
  }
}
