import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/views/widgets/common/status_content_body.dart';
import 'package:mobile_app/views/widgets/common/status_content_style.dart';

import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('shows optional action only when label and callback exist', (
    tester,
  ) async {
    await pumpWidgetInApp(
      tester,
      const StatusContentBody(
        icon: Icons.info,
        title: '状態',
        style: _testStatusStyle,
        actionLabel: null,
        onActionPressed: null,
      ),
    );

    expect(find.text('状態'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });
}

const _testStatusStyle = StatusContentStyle(
  decoration: BoxDecoration(color: Colors.white),
  iconColor: Colors.black,
  titleColor: Colors.black,
);
