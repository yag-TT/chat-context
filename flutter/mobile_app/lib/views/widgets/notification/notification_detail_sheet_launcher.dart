import 'package:flutter/material.dart';

import '../../../models/notification_item.dart';
import 'notification_detail_sheet.dart';

typedef NotificationDetailSheetLauncher =
    Future<void> Function({
      required BuildContext context,
      required NotificationItem notification,
    });

Future<void> showNotificationDetailSheet({
  required BuildContext context,
  required NotificationItem notification,
}) {
  debugPrint('[DBG] [Global] ::showNotificationDetailSheet() - 通知詳細シートを表示します');
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: false,
    isScrollControlled: true,
    builder: (context) {
      return NotificationDetailSheet(
        notification: notification,
        onClosePressed: () => Navigator.of(context).pop(),
      );
    },
  );
}
