import 'package:flutter_test/flutter_test.dart';

import '../helpers/change_notifier_counter.dart';
import '../helpers/test_view_models.dart';

void main() {
  test('loadNotifications stores mock notifications', () async {
    final viewModel = createTestNotificationViewModel();
    addTearDown(viewModel.dispose);

    expect(viewModel.notifications, isEmpty);
    expect(viewModel.hasLoadedNotifications, isFalse);
    expect(viewModel.isLoading, isFalse);

    await viewModel.loadNotifications();

    expect(viewModel.notifications, hasLength(4));
    expect(viewModel.hasLoadedNotifications, isTrue);
    expect(viewModel.errorMessage, isNull);
  });

  test('loadNotifications marks empty results as loaded', () async {
    final viewModel = createTestNotificationViewModel(notifications: []);
    addTearDown(viewModel.dispose);

    await viewModel.loadNotifications();

    expect(viewModel.notifications, isEmpty);
    expect(viewModel.hasLoadedNotifications, isTrue);
  });

  test('selectNotification updates selected notification once', () async {
    final viewModel = createTestNotificationViewModel();
    addTearDown(viewModel.dispose);
    final notifications = ChangeNotifierCounter(viewModel);

    await viewModel.loadNotifications();
    final notification = viewModel.notifications.first;
    notifications.reset();

    viewModel
      ..selectNotification(notification)
      ..selectNotification(notification);

    expect(viewModel.selectedNotification, notification);
    expect(notifications.count, 1);
  });

  test(
    'clearSelectedNotification notifies only when selection exists',
    () async {
      final viewModel = createTestNotificationViewModel();
      addTearDown(viewModel.dispose);

      await viewModel.loadNotifications();
      viewModel.selectNotification(viewModel.notifications.first);
      final notifications = ChangeNotifierCounter(viewModel);

      viewModel
        ..clearSelectedNotification()
        ..clearSelectedNotification();

      expect(viewModel.selectedNotification, isNull);
      expect(notifications.count, 1);
    },
  );
}
