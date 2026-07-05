import 'package:flutter/material.dart';

import '../../../models/notification_item.dart';
import 'notification_card_layout.dart';
import 'notification_styles.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.onPressed,
  });

  final NotificationItem notification;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [NotificationCard] ::build() - UIを描画します');
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isUnread
                  ? notification.color.withValues(alpha: 0.28)
                  : notificationCardBorderColor,
            ),
            boxShadow: const [notificationCardShadow],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: NotificationCardLayout(notification: notification),
          ),
        ),
      ),
    );
  }
}
