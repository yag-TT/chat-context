import 'package:flutter/material.dart';

import '../../../models/notification_item.dart';
import '../common/async_content_status_config.dart';
import '../common/async_content_switcher.dart';
import 'notification_content.dart';
import 'notification_styles.dart';

/// 通知一覧の取得状態に応じて、読み込み・エラー・一覧表示を切り替えます。
class NotificationScreenContent extends StatelessWidget {
  const NotificationScreenContent({
    super.key,
    required this.notifications,
    required this.hasLoadedNotifications,
    required this.errorMessage,
    required this.onNotificationPressed,
    required this.onRetryPressed,
  });

  final List<NotificationItem> notifications;
  final bool hasLoadedNotifications;
  final String? errorMessage;
  final ValueChanged<NotificationItem> onNotificationPressed;
  final VoidCallback onRetryPressed;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [NotificationScreenContent] ::build() - 画面を描画します');
    return AsyncContentSwitcher<List<NotificationItem>>(
      // 空リストも取得済みとして表示するため、取得完了フラグで未取得を判定します。
      data: hasLoadedNotifications ? notifications : null,
      dataBuilder: (context, notifications) => NotificationContent(
        notifications: notifications,
        onNotificationPressed: onNotificationPressed,
      ),
      errorMessage: errorMessage,
      statusConfig: AsyncContentStatusConfig(
        errorIcon: Icons.notifications_off_rounded,
        loadingIcon: Icons.notifications_active_rounded,
        loadingTitle: '通知を読み込み中',
        style: notificationStatusStyle,
        onRetryPressed: onRetryPressed,
      ),
    );
  }
}
