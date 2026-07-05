import 'package:flutter/material.dart';

import '../../../models/notification_item.dart';
import 'notification_styles.dart';

class NotificationDetailBody extends StatelessWidget {
  const NotificationDetailBody({super.key, required this.notification});

  final NotificationItem notification;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [NotificationDetailBody] ::build() - UIを描画します');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notification.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: notificationTextStrongColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          notification.message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: notificationTextSecondaryColor,
            height: 1.55,
          ),
        ),
      ],
    );
  }
}
