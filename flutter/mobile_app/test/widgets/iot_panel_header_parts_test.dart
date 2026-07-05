import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/views/widgets/iot/iot_panel_header_icon.dart';
import 'package:mobile_app/views/widgets/iot/iot_panel_header_text.dart';

import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('IotPanelHeaderIcon shows icon', (tester) async {
    await pumpWidgetInApp(
      tester,
      const IotPanelHeaderIcon(
        icon: Icons.lightbulb_rounded,
        iconColor: Colors.amber,
      ),
    );

    expect(find.byIcon(Icons.lightbulb_rounded), findsOneWidget);
  });

  testWidgets('IotPanelHeaderText shows title and subtitle', (tester) async {
    await pumpWidgetInApp(
      tester,
      const IotPanelHeaderText(title: 'リビングライト', subtitle: '明るさ 72%'),
    );

    expect(find.text('リビングライト'), findsOneWidget);
    expect(find.text('明るさ 72%'), findsOneWidget);
  });
}
