import 'package:flutter/material.dart';

import '../../../models/notification_item.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key, required this.notification});

  final NotificationItem notification;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [NotificationIcon] ::build() - UIを描画します');
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: 44,
          height: 44,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: notification.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(notification.icon, color: notification.color, size: 24),
          ),
        ),
        if (notification.isUnread)
          Positioned(
            top: -2,
            right: -2,
            child: SizedBox(
              width: 10,
              height: 10,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
