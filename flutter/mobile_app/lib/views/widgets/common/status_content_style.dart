import 'package:flutter/material.dart';

class StatusContentStyle {
  const StatusContentStyle({
    required this.decoration,
    required this.iconColor,
    required this.titleColor,
    this.useSafeArea = true,
  });

  final Decoration decoration;
  final Color iconColor;
  final Color titleColor;
  final bool useSafeArea;
}
