import 'package:flutter/material.dart';

import '../../../models/notification_item.dart';
import 'notification_detail_action.dart';
import 'notification_detail_body.dart';
import 'notification_detail_header.dart';
import 'notification_sheet_drag_handle.dart';

class NotificationDetailSheet extends StatelessWidget {
  const NotificationDetailSheet({
    super.key,
    required this.notification,
    required this.onClosePressed,
  });

  final NotificationItem notification;
  final VoidCallback onClosePressed;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [NotificationDetailSheet] ::build() - UIを描画します');
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NotificationSheetDragHandle(),
            const SizedBox(height: 18),
            NotificationDetailHeader(
              notification: notification,
              onClosePressed: onClosePressed,
            ),
            const SizedBox(height: 18),
            NotificationDetailBody(notification: notification),
            const SizedBox(height: 20),
            NotificationDetailAction(onPressed: onClosePressed),
          ],
        ),
      ),
    );
  }
}
