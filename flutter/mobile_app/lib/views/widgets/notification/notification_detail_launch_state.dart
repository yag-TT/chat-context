import '../../../models/notification_item.dart';
import 'package:flutter/foundation.dart';

class NotificationDetailLaunchState {
  bool _isOpen = false;

  bool canLaunch(NotificationItem? notification, {required bool isMounted}) {
    debugPrint(
      '[DBG] [NotificationDetailLaunchState] ::canLaunch() - 通知詳細を表示できるか確認します',
    );
    return notification != null && !_isOpen && isMounted;
  }

  void markOpened() {
    debugPrint(
      '[DBG] [NotificationDetailLaunchState] ::markOpened() - 通知詳細を表示中の状態にします',
    );
    _isOpen = true;
  }

  void markClosed() {
    debugPrint(
      '[DBG] [NotificationDetailLaunchState] ::markClosed() - 通知詳細を閉じた状態にします',
    );
    _isOpen = false;
  }
}
