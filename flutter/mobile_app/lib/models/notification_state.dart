import 'package:flutter/foundation.dart';

import 'notification_item.dart';

/// 通知一覧と詳細表示対象の選択状態をまとめた状態です。
///
/// `hasLoadedNotifications` を持つことで、未取得状態と取得済み0件を区別します。
class NotificationState {
  NotificationState({
    List<NotificationItem> notifications = const [],
    this.selectedNotification,
    this.hasLoadedNotifications = false,
  }) : notifications = List.unmodifiable(notifications);

  final List<NotificationItem> notifications;
  final NotificationItem? selectedNotification;
  final bool hasLoadedNotifications;

  NotificationState copyWith({
    List<NotificationItem>? notifications,
    NotificationItem? selectedNotification,
    bool? hasLoadedNotifications,
  }) {
    debugPrint('[DBG] [NotificationState] ::copyWith() - 変更後の状態を作成します');
    return NotificationState(
      notifications: notifications ?? this.notifications,
      selectedNotification: selectedNotification ?? this.selectedNotification,
      hasLoadedNotifications:
          hasLoadedNotifications ?? this.hasLoadedNotifications,
    );
  }

  NotificationState clearSelectedNotification() {
    debugPrint(
      '[DBG] [NotificationState] ::clearSelectedNotification() - 選択中の通知を解除します',
    );
    return NotificationState(
      notifications: notifications,
      hasLoadedNotifications: hasLoadedNotifications,
    );
  }

  NotificationState withLoadedNotifications(
    List<NotificationItem> notifications,
  ) {
    debugPrint(
      '[DBG] [NotificationState] ::withLoadedNotifications() - 取得済み通知を状態へ反映します',
    );
    final selectedNotification = this.selectedNotification;
    // 再取得後も同じ通知が残っていれば、新しい一覧内のインスタンスへ選択を張り替えます。
    final nextSelectedNotification = selectedNotification == null
        ? null
        : _findMatchingNotification(notifications, selectedNotification);

    return NotificationState(
      notifications: notifications,
      selectedNotification: nextSelectedNotification,
      hasLoadedNotifications: true,
    );
  }

  NotificationItem? _findMatchingNotification(
    List<NotificationItem> notifications,
    NotificationItem selectedNotification,
  ) {
    debugPrint(
      '[DBG] [NotificationState] ::_findMatchingNotification() - 再取得後の通知一覧から選択中通知を探します',
    );
    for (final notification in notifications) {
      if (notification == selectedNotification) {
        return notification;
      }
    }

    return null;
  }

  @override
  bool operator ==(Object other) {
    debugPrint('[DBG] [NotificationState] ::operator==() - 同じ値か比較します');
    return identical(this, other) ||
        other is NotificationState &&
            listEquals(other.notifications, notifications) &&
            other.selectedNotification == selectedNotification &&
            other.hasLoadedNotifications == hasLoadedNotifications;
  }

  @override
  int get hashCode {
    debugPrint('[DBG] [NotificationState] ::hashCode() - ハッシュ値を計算します');
    return Object.hash(
      Object.hashAll(notifications),
      selectedNotification,
      hasLoadedNotifications,
    );
  }
}
