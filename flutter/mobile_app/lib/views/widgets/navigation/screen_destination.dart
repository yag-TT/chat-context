import 'package:flutter/material.dart';

import '../../../models/app_screen.dart';

class ScreenDestination {
  const ScreenDestination({
    required this.screen,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final AppScreen screen;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
}
