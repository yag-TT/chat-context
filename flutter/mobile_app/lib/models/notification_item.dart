import 'package:flutter/material.dart';

class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.message,
    required this.receivedAtLabel,
    required this.category,
    required this.icon,
    required this.color,
    required this.isUnread,
  });

  final String title;
  final String message;
  final String receivedAtLabel;
  final String category;
  final IconData icon;
  final Color color;
  final bool isUnread;

  @override
  bool operator ==(Object other) {
    debugPrint('[DBG] [NotificationItem] ::operator==() - 同じ値か比較します');
    return identical(this, other) ||
        other is NotificationItem &&
            other.title == title &&
            other.message == message &&
            other.receivedAtLabel == receivedAtLabel &&
            other.category == category &&
            other.icon == icon &&
            other.color == color &&
            other.isUnread == isUnread;
  }

  @override
  int get hashCode {
    debugPrint('[DBG] [NotificationItem] ::hashCode() - ハッシュ値を計算します');
    return Object.hash(
      title,
      message,
      receivedAtLabel,
      category,
      icon,
      color,
      isUnread,
    );
  }
}
