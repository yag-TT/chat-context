import 'package:flutter/material.dart';

import '../../models/notification_item.dart';

const mockNotifications = [
  NotificationItem(
    title: '雨雲が近づいています',
    message: '渋谷区では22:30頃から弱い雨が降る可能性があります。',
    receivedAtLabel: '5分前',
    category: '天気アラート',
    icon: Icons.umbrella_rounded,
    color: Colors.indigo,
    isUnread: true,
  ),
  NotificationItem(
    title: '明日の予定を確認しましょう',
    message: '午前中は晴れ、午後は湿度が高くなる見込みです。',
    receivedAtLabel: '18分前',
    category: 'リマインダー',
    icon: Icons.event_available_rounded,
    color: Colors.teal,
    isUnread: true,
  ),
  NotificationItem(
    title: '週間予報が更新されました',
    message: '週末は気温が下がり、日曜日は雨具があると安心です。',
    receivedAtLabel: '1時間前',
    category: '予報更新',
    icon: Icons.update_rounded,
    color: Colors.deepOrange,
    isUnread: false,
  ),
  NotificationItem(
    title: '紫外線が強めです',
    message: '明日の日中はUV指数が高めです。外出時は対策をおすすめします。',
    receivedAtLabel: '昨日',
    category: '生活情報',
    icon: Icons.wb_sunny_rounded,
    color: Colors.amber,
    isUnread: false,
  ),
];
