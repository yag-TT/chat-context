import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/mock_data/mock_notification_data.dart';
import 'package:mobile_app/models/notification_item.dart';
import 'package:mobile_app/views/widgets/notification/notification_screen_content.dart';

import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('shows loading when notifications and error are absent', (
    tester,
  ) async {
    await pumpWidgetInApp(
      tester,
      const NotificationScreenContent(
        notifications: [],
        hasLoadedNotifications: false,
        errorMessage: null,
        onNotificationPressed: _ignoreNotification,
        onRetryPressed: _noop,
      ),
    );

    expect(find.text('通知を読み込み中'), findsOneWidget);
  });

  testWidgets('shows notifications when notifications are present', (
    tester,
  ) async {
    await pumpWidgetInApp(
      tester,
      const NotificationScreenContent(
        notifications: mockNotifications,
        hasLoadedNotifications: true,
        errorMessage: 'error',
        onNotificationPressed: _ignoreNotification,
        onRetryPressed: _noop,
      ),
    );

    expect(find.text('雨雲が近づいています'), findsOneWidget);
    expect(find.text('error'), findsNothing);
  });

  testWidgets('shows empty notification content after empty result is loaded', (
    tester,
  ) async {
    await pumpWidgetInApp(
      tester,
      const NotificationScreenContent(
        notifications: [],
        hasLoadedNotifications: true,
        errorMessage: null,
        onNotificationPressed: _ignoreNotification,
        onRetryPressed: _noop,
      ),
    );

    expect(find.text('通知'), findsOneWidget);
    expect(find.text('新しい通知はありません'), findsOneWidget);
    expect(find.text('通知を読み込み中'), findsNothing);
  });
}

void _ignoreNotification(NotificationItem notification) {}

void _noop() {}
