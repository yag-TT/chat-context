import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/notification_item.dart';

void main() {
  test('items with same values are equal', () {
    const first = NotificationItem(
      title: '通知',
      message: '本文',
      receivedAtLabel: '今',
      category: '天気',
      icon: Icons.info_outline,
      color: Colors.blue,
      isUnread: true,
    );
    const second = NotificationItem(
      title: '通知',
      message: '本文',
      receivedAtLabel: '今',
      category: '天気',
      icon: Icons.info_outline,
      color: Colors.blue,
      isUnread: true,
    );

    expect(first, second);
    expect(first.hashCode, second.hashCode);
  });
}
