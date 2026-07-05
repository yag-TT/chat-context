import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const seedColor = Colors.teal;

  static ThemeData get light {
    return ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: seedColor));
  }
}
