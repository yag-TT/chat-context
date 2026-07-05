import 'package:flutter/material.dart';

import '../../../viewmodels/notification_view_model.dart';
import '../common/view_model_builder.dart';
import 'notification_screen_content.dart';

/// NotificationViewModelを監視し、通知一覧と選択操作を画面へ渡します。
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key, required this.viewModel});

  final NotificationViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [NotificationScreen] ::build() - 画面を描画します');
    return ViewModelBuilder(
      viewModel: viewModel,
      builder: (context, viewModel) {
        return NotificationScreenContent(
          notifications: viewModel.notifications,
          hasLoadedNotifications: viewModel.hasLoadedNotifications,
          errorMessage: viewModel.errorMessage,
          onNotificationPressed: viewModel.selectNotification,
          onRetryPressed: viewModel.loadNotifications,
        );
      },
    );
  }
}
