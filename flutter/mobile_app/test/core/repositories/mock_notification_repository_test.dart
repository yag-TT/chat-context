import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/repositories/mock_notification_repository.dart';
import 'package:mobile_app/models/notification_item.dart';

void main() {
  test('fetchNotifications returns mock notifications', () async {
    final repository = MockNotificationRepository();

    final notifications = await repository.fetchNotifications();

    expect(notifications, hasLength(4));
    expect(notifications.first.title, '雨雲が近づいています');
    expect(notifications.where((item) => item.isUnread), hasLength(2));
  });

  test('fetchNotifications returns injected notifications', () async {
    const injectedNotifications = [
      NotificationItem(
        title: 'テスト通知',
        message: '差し替えた通知です。',
        receivedAtLabel: '今',
        category: 'テスト',
        icon: Icons.info_outline,
        color: Colors.grey,
        isUnread: false,
      ),
    ];
    final repository = MockNotificationRepository(
      notifications: injectedNotifications,
    );

    final notifications = await repository.fetchNotifications();

    expect(notifications, injectedNotifications);
    expect(notifications, isNot(same(injectedNotifications)));
  });

  test('fetchNotifications returns an unmodifiable list', () async {
    final repository = MockNotificationRepository();

    final notifications = await repository.fetchNotifications();

    expect(
      () => notifications.add(
        const NotificationItem(
          title: '変更',
          message: '外部から追加',
          receivedAtLabel: '今',
          category: 'テスト',
          icon: Icons.add_alert,
          color: Colors.red,
          isUnread: true,
        ),
      ),
      throwsUnsupportedError,
    );
  });

  test('constructor snapshots injected notifications', () async {
    final injectedNotifications = [
      const NotificationItem(
        title: 'テスト通知',
        message: '差し替えた通知です。',
        receivedAtLabel: '今',
        category: 'テスト',
        icon: Icons.info_outline,
        color: Colors.grey,
        isUnread: false,
      ),
    ];
    final repository = MockNotificationRepository(
      notifications: injectedNotifications,
    );

    injectedNotifications.add(
      const NotificationItem(
        title: '追加通知',
        message: '生成後に追加した通知です。',
        receivedAtLabel: '今',
        category: 'テスト',
        icon: Icons.add_alert,
        color: Colors.red,
        isUnread: true,
      ),
    );

    final notifications = await repository.fetchNotifications();

    expect(notifications, hasLength(1));
    expect(notifications.first.title, 'テスト通知');
  });
}
