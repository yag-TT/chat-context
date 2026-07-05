import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/app_theme.dart';

void main() {
  test('light theme uses the app seed color', () {
    final theme = AppTheme.light;

    expect(AppTheme.seedColor, Colors.teal);
    expect(theme.colorScheme.brightness, Brightness.light);
  });
}
