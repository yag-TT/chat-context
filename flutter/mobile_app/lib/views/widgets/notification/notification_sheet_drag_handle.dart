import 'package:flutter/material.dart';

import 'notification_styles.dart';

class NotificationSheetDragHandle extends StatelessWidget {
  const NotificationSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [NotificationSheetDragHandle] ::build() - UIを描画します');
    return Center(
      child: SizedBox(
        width: 42,
        height: 4,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: notificationSheetHandleColor,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}
