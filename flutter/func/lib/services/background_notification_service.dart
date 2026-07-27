import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract interface class BackgroundNotificationScheduler {
  Future<bool> arePermissionsGranted();

  Future<bool> requestPermissions();

  Future<void> scheduleAfter(Duration delay);

  Future<void> cancelSchedule();
}

class AwesomeBackgroundNotificationScheduler
    implements BackgroundNotificationScheduler {
  static const int notificationId = 1001;
  static const String channelKey = 'background_channel';

  static const _essentialPermissions = [
    NotificationPermission.Alert,
    NotificationPermission.PreciseAlarms,
  ];

  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: channelKey,
        channelName: 'バックグラウンド通知',
        channelDescription: 'アプリがバックグラウンドに移動した後に表示する通知',
        defaultColor: const Color(0xFF3F51B5),
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableVibration: true,
      ),
    ], debug: kDebugMode);

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onBackgroundNotificationAction,
    );
  }

  @override
  Future<bool> arePermissionsGranted() async {
    final granted = await AwesomeNotifications().checkPermissionList(
      channelKey: channelKey,
      permissions: _essentialPermissions,
    );
    return _essentialPermissions.every(granted.contains);
  }

  @override
  Future<bool> requestPermissions() async {
    await AwesomeNotifications().requestPermissionToSendNotifications(
      channelKey: channelKey,
      permissions: const [
        NotificationPermission.Alert,
        NotificationPermission.Sound,
        NotificationPermission.Vibration,
      ],
    );

    final granted = await AwesomeNotifications().checkPermissionList(
      channelKey: channelKey,
      permissions: _essentialPermissions,
    );
    if (!granted.contains(NotificationPermission.PreciseAlarms)) {
      await AwesomeNotifications().showAlarmPage();
      return false;
    }

    return arePermissionsGranted();
  }

  @override
  Future<void> scheduleAfter(Duration delay) async {
    final created = await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: channelKey,
        actionType: ActionType.Default,
        title: 'バックグラウンド通知',
        body: 'バックグラウンドに移動してから5秒経過しました。',
        category: NotificationCategory.Reminder,
        notificationLayout: NotificationLayout.Default,
        displayOnForeground: false,
        displayOnBackground: true,
      ),
      schedule: NotificationInterval(
        interval: delay,
        repeats: false,
        preciseAlarm: true,
        allowWhileIdle: true,
      ),
    );

    if (!created) {
      throw StateError('通知を予約できませんでした。');
    }
  }

  @override
  Future<void> cancelSchedule() {
    return AwesomeNotifications().cancelSchedule(notificationId);
  }
}

@pragma('vm:entry-point')
Future<void> onBackgroundNotificationAction(ReceivedAction action) async {
  // The default action opens the app. No additional navigation is required.
}
