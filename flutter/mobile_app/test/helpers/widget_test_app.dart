import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/app_theme.dart';

Future<void> pumpWidgetInApp(WidgetTester tester, Widget child) {
  return tester.pumpWidget(MaterialApp(theme: AppTheme.light, home: child));
}
