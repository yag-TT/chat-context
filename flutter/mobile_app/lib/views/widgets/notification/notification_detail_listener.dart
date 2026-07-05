import 'package:flutter/material.dart';

import '../../../models/notification_item.dart';
import '../../../viewmodels/notification_view_model.dart';
import 'notification_detail_launch_state.dart';
import 'notification_detail_sheet_launcher.dart';

/// NotificationViewModelの選択状態を監視して、詳細シートを起動します。
///
/// 一覧Widgetからは通知選択だけを行い、シート表示の副作用はこのWidgetに閉じ込めます。
class NotificationDetailListener extends StatefulWidget {
  const NotificationDetailListener({
    super.key,
    required this.viewModel,
    required this.child,
    this.showDetailSheet = showNotificationDetailSheet,
  });

  final NotificationViewModel viewModel;
  final Widget child;
  final NotificationDetailSheetLauncher showDetailSheet;

  @override
  // ignore: no_logic_in_create_state
  State<NotificationDetailListener> createState() {
    debugPrint(
      '[DBG] [NotificationDetailListener] ::createState() - Stateを生成します',
    );
    return _NotificationDetailListenerState();
  }
}

class _NotificationDetailListenerState
    extends State<NotificationDetailListener> {
  final NotificationDetailLaunchState _launchState =
      NotificationDetailLaunchState();

  @override
  void initState() {
    debugPrint(
      '[DBG] [NotificationDetailListener::NotificationDetailListenerState] ::initState() - 初期化処理を開始します',
    );
    super.initState();
    _attachViewModel(widget.viewModel);
    _scheduleSelectedNotificationCheck();
  }

  @override
  void didUpdateWidget(NotificationDetailListener oldWidget) {
    debugPrint(
      '[DBG] [NotificationDetailListener::NotificationDetailListenerState] ::didUpdateWidget() - Widget更新時の状態差し替えを確認します',
    );
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel == widget.viewModel) {
      return;
    }

    _detachViewModel(oldWidget.viewModel);
    _attachViewModel(widget.viewModel);
    _scheduleSelectedNotificationCheck();
  }

  @override
  void dispose() {
    debugPrint(
      '[DBG] [NotificationDetailListener::NotificationDetailListenerState] ::dispose() - 保持しているリソースを破棄します',
    );
    _detachViewModel(widget.viewModel);
    super.dispose();
  }

  void _showSelectedNotification() {
    debugPrint(
      '[DBG] [NotificationDetailListener::NotificationDetailListenerState] ::_showSelectedNotification() - 選択中通知の詳細表示を開始します',
    );
    final viewModel = widget.viewModel;
    final notification = viewModel.selectedNotification;
    if (!_launchState.canLaunch(notification, isMounted: mounted)) {
      return;
    }

    _showNotificationDetail(viewModel, notification!);
  }

  void _showNotificationDetail(
    NotificationViewModel viewModel,
    NotificationItem notification,
  ) {
    debugPrint(
      '[DBG] [NotificationDetailListener::NotificationDetailListenerState] ::_showNotificationDetail() - 通知詳細シートの表示処理を実行します',
    );
    _launchState.markOpened();
    // 起動元のViewModelを渡しておき、表示中にWidgetが別ViewModelへ差し替わっても
    // シートを開いた側の選択状態だけを閉じる時に解除します。
    widget
        .showDetailSheet(context: context, notification: notification)
        .whenComplete(() {
          _handleNotificationDetailClosed(viewModel);
        });
  }

  void _handleNotificationDetailClosed(NotificationViewModel viewModel) {
    debugPrint(
      '[DBG] [NotificationDetailListener::NotificationDetailListenerState] ::_handleNotificationDetailClosed() - 通知詳細シートを閉じた後の状態を更新します',
    );
    if (!mounted) {
      return;
    }

    _launchState.markClosed();
    viewModel.clearSelectedNotification();
  }

  void _attachViewModel(NotificationViewModel viewModel) {
    debugPrint(
      '[DBG] [NotificationDetailListener::NotificationDetailListenerState] ::_attachViewModel() - ViewModelの変更監視を開始します',
    );
    viewModel.addListener(_showSelectedNotification);
  }

  void _detachViewModel(NotificationViewModel viewModel) {
    debugPrint(
      '[DBG] [NotificationDetailListener::NotificationDetailListenerState] ::_detachViewModel() - ViewModelの変更監視を解除します',
    );
    viewModel.removeListener(_showSelectedNotification);
  }

  void _scheduleSelectedNotificationCheck() {
    debugPrint(
      '[DBG] [NotificationDetailListener::NotificationDetailListenerState] ::_scheduleSelectedNotificationCheck() - 選択中通知の表示確認を予約します',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showSelectedNotification();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      '[DBG] [NotificationDetailListener::NotificationDetailListenerState] ::build() - UIを描画します',
    );
    return widget.child;
  }
}
