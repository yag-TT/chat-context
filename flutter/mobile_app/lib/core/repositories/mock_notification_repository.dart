import '../mock_data/mock_notification_data.dart';
import '../../models/notification_item.dart';
import 'mock_repository_snapshot.dart';
import 'notification_repository.dart';
import 'package:flutter/foundation.dart';

class MockNotificationRepository implements NotificationRepository {
  MockNotificationRepository({
    List<NotificationItem> notifications = mockNotifications,
  }) : notifications = snapshotRepositoryList(notifications);

  final List<NotificationItem> notifications;

  @override
  Future<List<NotificationItem>> fetchNotifications() async {
    debugPrint(
      '[DBG] [MockNotificationRepository] ::fetchNotifications() - Repositoryからモックデータを取得します',
    );
    return notifications;
  }
}
