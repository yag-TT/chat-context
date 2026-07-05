import 'package:flutter/material.dart';

import '../../../models/notification_item.dart';
import 'notification_styles.dart';

class NotificationCardBody extends StatelessWidget {
  const NotificationCardBody({super.key, required this.notification});

  final NotificationItem notification;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [NotificationCardBody] ::build() - UIを描画します');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: notificationTextPrimaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              notification.receivedAtLabel,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: notificationTextMutedColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          notification.category,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: notification.color,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          notification.message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: notificationTextSecondaryColor,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
