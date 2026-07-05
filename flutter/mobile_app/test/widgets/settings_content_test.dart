import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/settings_state.dart';
import 'package:mobile_app/views/widgets/settings/settings_actions.dart';
import 'package:mobile_app/views/widgets/settings/settings_content.dart';

import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('renders settings groups from state', (tester) async {
    await pumpWidgetInApp(
      tester,
      Scaffold(
        body: SettingsContent(
          state: SettingsState(refreshIntervalMinutes: 30),
          actions: SettingsActions(
            onWeatherAlertChanged: _ignoreBool,
            onDeviceAutomationChanged: _ignoreBool,
            onDarkModePreviewChanged: _ignoreBool,
            onRefreshIntervalChanged: _ignoreInt,
          ),
        ),
      ),
    );

    expect(find.text('設定'), findsOneWidget);
    expect(find.text('通知設定'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('表示'), 120);

    expect(find.text('表示'), findsOneWidget);
    expect(find.text('データ更新間隔'), findsOneWidget);
    expect(find.text('30分'), findsOneWidget);
  });
}

void _ignoreBool(bool value) {}

void _ignoreInt(int value) {}
