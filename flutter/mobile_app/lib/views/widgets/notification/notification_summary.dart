import 'package:flutter/material.dart';

import '../../../models/notification_item.dart';
import 'notification_styles.dart';

class NotificationSummary extends StatelessWidget {
  const NotificationSummary({super.key, required this.notifications});

  final List<NotificationItem> notifications;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [NotificationSummary] ::build() - UIを描画します');
    final unreadCount = notifications.where((item) => item.isUnread).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '通知',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: notificationSummaryTitleColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          unreadCount == 0 ? '新しい通知はありません' : '未読の通知が$unreadCount件あります',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: notificationSummarySubtitleColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
