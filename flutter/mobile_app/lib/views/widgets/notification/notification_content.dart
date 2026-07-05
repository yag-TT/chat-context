import 'package:flutter/material.dart';

import '../../../models/notification_item.dart';
import '../common/padded_sliver_box.dart';
import '../common/screen_surface.dart';
import '../common/spaced_sliver_list.dart';
import 'notification_card.dart';
import 'notification_summary.dart';
import 'notification_styles.dart';

class NotificationContent extends StatelessWidget {
  const NotificationContent({
    super.key,
    required this.notifications,
    required this.onNotificationPressed,
  });

  final List<NotificationItem> notifications;
  final ValueChanged<NotificationItem> onNotificationPressed;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [NotificationContent] ::build() - UIを描画します');
    return ScreenSurface(
      decoration: notificationBackgroundDecoration,
      child: CustomScrollView(
        slivers: [
          PaddedSliverBox(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: NotificationSummary(notifications: notifications),
          ),
          SpacedSliverList(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
            spacing: 10,
            children: [
              for (final notification in notifications)
                NotificationCard(
                  notification: notification,
                  onPressed: () => onNotificationPressed(notification),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
