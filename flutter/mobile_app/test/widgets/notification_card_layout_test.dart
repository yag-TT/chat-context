import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/mock_data/mock_notification_data.dart';
import 'package:mobile_app/views/widgets/notification/notification_card_layout.dart';

import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('shows notification body and affordance icon', (tester) async {
    await pumpWidgetInApp(
      tester,
      NotificationCardLayout(notification: mockNotifications[0]),
    );

    expect(find.text('雨雲が近づいています'), findsOneWidget);
    expect(find.text('天気アラート'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
  });
}
