import '../core/repositories/notification_repository.dart';
import '../models/notification_item.dart';
import '../models/notification_state.dart';
import 'async_view_model.dart';
import 'package:flutter/foundation.dart';

/// 通知一覧の取得状態と、詳細表示対象の通知選択を管理します。
class NotificationViewModel extends AsyncViewModel {
  NotificationViewModel({
    required NotificationRepository notificationRepository,
  }) : _notificationRepository = notificationRepository;

  final NotificationRepository _notificationRepository;
  NotificationState _state = NotificationState();

  List<NotificationItem> get notifications {
    debugPrint('[DBG] [NotificationViewModel] ::notifications() - 通知一覧を参照します');
    return _state.notifications;
  }

  NotificationItem? get selectedNotification {
    debugPrint(
      '[DBG] [NotificationViewModel] ::selectedNotification() - 選択中の通知を参照します',
    );
    return _state.selectedNotification;
  }

  bool get hasLoadedNotifications {
    debugPrint(
      '[DBG] [NotificationViewModel] ::hasLoadedNotifications() - 通知読み込み済み状態を参照します',
    );
    return _state.hasLoadedNotifications;
  }

  Future<void> loadNotifications() async {
    debugPrint(
      '[DBG] [NotificationViewModel] ::loadNotifications() - 通知一覧を読み込みます',
    );
    await runLoadValue(
      errorMessage: '通知を取得できませんでした。',
      load: _notificationRepository.fetchNotifications,
      onData: (notifications) {
        _state = _state.withLoadedNotifications(notifications);
      },
    );
  }

  void selectNotification(NotificationItem notification) {
    debugPrint(
      '[DBG] [NotificationViewModel] ::selectNotification() - 選択された通知を状態へ反映します',
    );
    _updateState(_state.copyWith(selectedNotification: notification));
  }

  void clearSelectedNotification() {
    debugPrint(
      '[DBG] [NotificationViewModel] ::clearSelectedNotification() - 選択中の通知を解除します',
    );
    _updateState(_state.clearSelectedNotification());
  }

  void _updateState(NotificationState nextState) {
    debugPrint('[DBG] [NotificationViewModel] ::_updateState() - 状態更新処理を実行します');
    // 選択中通知や一覧が変わった場合だけ、購読中のWidgetへ通知します。
    updateValue(_state, nextState, (value) {
      debugPrint(
        '[DBG] [NotificationViewModel] ::updateValue() - 値の変化を確認して状態を更新します',
      );
      _state = value;
    });
  }
}
