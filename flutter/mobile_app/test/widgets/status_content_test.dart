import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/views/widgets/common/status_content.dart';
import 'package:mobile_app/views/widgets/common/status_content_style.dart';

import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('loading status shows title without retry action', (
    tester,
  ) async {
    await pumpWidgetInApp(
      tester,
      const StatusContent.loading(
        icon: Icons.sync,
        title: '読み込み中',
        style: _testStatusStyle,
      ),
    );

    expect(find.text('読み込み中'), findsOneWidget);
    expect(find.text('再読み込み'), findsNothing);
  });

  testWidgets('error status calls retry action', (tester) async {
    var retryCount = 0;

    await pumpWidgetInApp(
      tester,
      StatusContent.error(
        icon: Icons.error_outline,
        title: 'エラー',
        style: _testStatusStyle,
        onRetryPressed: () {
          retryCount += 1;
        },
      ),
    );

    await tester.tap(find.text('再読み込み'));

    expect(find.text('エラー'), findsOneWidget);
    expect(retryCount, 1);
  });
}

const _testStatusStyle = StatusContentStyle(
  decoration: BoxDecoration(color: Colors.white),
  iconColor: Colors.black,
  titleColor: Colors.black,
);
