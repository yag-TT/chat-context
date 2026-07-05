import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/mock_data/mock_notification_data.dart';
import 'package:mobile_app/models/notification_item.dart';
import 'package:mobile_app/models/notification_state.dart';

void main() {
  test('copyWith updates selected notification fields', () {
    final state = NotificationState().copyWith(
      notifications: mockNotifications,
      selectedNotification: mockNotifications.first,
      hasLoadedNotifications: true,
    );

    expect(state.notifications, mockNotifications);
    expect(state.selectedNotification, mockNotifications.first);
    expect(state.hasLoadedNotifications, isTrue);
  });

  test('clearSelectedNotification keeps notifications', () {
    final state = NotificationState(
      notifications: mockNotifications,
      selectedNotification: mockNotifications.first,
      hasLoadedNotifications: true,
    ).clearSelectedNotification();

    expect(state.notifications, mockNotifications);
    expect(state.selectedNotification, isNull);
    expect(state.hasLoadedNotifications, isTrue);
  });

  test('withLoadedNotifications marks notifications as loaded', () {
    final state = NotificationState().withLoadedNotifications(
      mockNotifications,
    );

    expect(state.notifications, mockNotifications);
    expect(state.hasLoadedNotifications, isTrue);
  });

  test(
    'withLoadedNotifications keeps selected notification when it remains',
    () {
      final state = NotificationState(
        notifications: mockNotifications,
        selectedNotification: mockNotifications.first,
        hasLoadedNotifications: true,
      ).withLoadedNotifications(List.of(mockNotifications));

      expect(state.selectedNotification, mockNotifications.first);
    },
  );

  test(
    'withLoadedNotifications uses matching loaded notification instance',
    () {
      final copiedNotifications = [
        for (final notification in mockNotifications)
          NotificationItem(
            title: notification.title,
            message: notification.message,
            receivedAtLabel: notification.receivedAtLabel,
            category: notification.category,
            icon: notification.icon,
            color: notification.color,
            isUnread: notification.isUnread,
          ),
      ];

      final state = NotificationState(
        notifications: mockNotifications,
        selectedNotification: mockNotifications.first,
        hasLoadedNotifications: true,
      ).withLoadedNotifications(copiedNotifications);

      expect(state.selectedNotification, same(copiedNotifications.first));
    },
  );

  test('withLoadedNotifications clears missing selected notification', () {
    final state = NotificationState(
      notifications: mockNotifications,
      selectedNotification: mockNotifications.first,
      hasLoadedNotifications: true,
    ).withLoadedNotifications(mockNotifications.skip(1).toList());

    expect(state.selectedNotification, isNull);
  });

  test('states with same values are equal', () {
    expect(
      NotificationState(
        notifications: mockNotifications,
        hasLoadedNotifications: true,
      ),
      NotificationState(
        notifications: mockNotifications,
        hasLoadedNotifications: true,
      ),
    );
  });

  test('states with copied notification values are equal', () {
    final copiedNotifications = [
      for (final notification in mockNotifications)
        NotificationItem(
          title: notification.title,
          message: notification.message,
          receivedAtLabel: notification.receivedAtLabel,
          category: notification.category,
          icon: notification.icon,
          color: notification.color,
          isUnread: notification.isUnread,
        ),
    ];

    expect(
      NotificationState(notifications: mockNotifications),
      NotificationState(notifications: copiedNotifications),
    );
  });

  test('notifications are immutable after construction', () {
    final source = List.of(mockNotifications);
    final state = NotificationState(notifications: source);

    source.clear();

    expect(state.notifications, mockNotifications);
    expect(() => state.notifications.clear(), throwsUnsupportedError);
  });
}
