import 'package:flutter/material.dart';

import '../common/status_content_style.dart';

const notificationBackgroundColor = Color(0xFFFFF7F2);
const notificationBackgroundDecoration = BoxDecoration(
  color: notificationBackgroundColor,
);
const notificationTextPrimaryColor = Color(0xDB000000);
const notificationTextStrongColor = Color(0xE0000000);
const notificationTextSecondaryColor = Color(0xA3000000);
const notificationTextMutedColor = Color(0x75000000);
const notificationChevronColor = Color(0x4D000000);
const notificationCardBorderColor = Color(0x0F000000);
const notificationSheetHandleColor = Color(0x29000000);

final notificationSummaryTitleColor = Colors.deepOrange.shade900;
final notificationSummarySubtitleColor = Colors.deepOrange.shade700;

final notificationStatusStyle = StatusContentStyle(
  decoration: notificationBackgroundDecoration,
  iconColor: Colors.deepOrange,
  titleColor: notificationSummaryTitleColor,
  useSafeArea: false,
);

const notificationCardShadow = BoxShadow(
  color: notificationCardBorderColor,
  blurRadius: 18,
  offset: Offset(0, 8),
);
