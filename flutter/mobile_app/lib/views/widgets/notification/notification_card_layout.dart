import 'package:flutter/material.dart';

import '../../../models/notification_item.dart';
import 'notification_card_body.dart';
import 'notification_icon.dart';
import 'notification_styles.dart';

class NotificationCardLayout extends StatelessWidget {
  const NotificationCardLayout({super.key, required this.notification});

  final NotificationItem notification;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [NotificationCardLayout] ::build() - UIを描画します');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NotificationIcon(notification: notification),
        const SizedBox(width: 14),
        Expanded(child: NotificationCardBody(notification: notification)),
        const SizedBox(width: 8),
        const Icon(
          Icons.chevron_right_rounded,
          color: notificationChevronColor,
          size: 22,
        ),
      ],
    );
  }
}
