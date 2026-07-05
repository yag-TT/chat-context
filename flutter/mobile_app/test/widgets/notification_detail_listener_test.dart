import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/views/widgets/notification/notification_detail_listener.dart';

import '../helpers/test_view_models.dart';
import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('shows selected notification detail sheet and clears selection', (
    tester,
  ) async {
    final viewModel = await createLoadedTestNotificationViewModel();
    addTearDown(viewModel.dispose);

    await pumpWidgetInApp(
      tester,
      NotificationDetailListener(
        viewModel: viewModel,
        child: const Scaffold(body: SizedBox.shrink()),
      ),
    );

    viewModel.selectNotification(viewModel.notifications.first);
    await tester.pumpAndSettle();

    expect(find.text('雨雲が近づいています'), findsOneWidget);
    expect(find.text('確認しました'), findsOneWidget);

    await tester.tap(find.text('確認しました'));
    await tester.pumpAndSettle();

    expect(viewModel.selectedNotification, isNull);
  });

  testWidgets('does not launch another detail sheet while one is open', (
    tester,
  ) async {
    final viewModel = await createLoadedTestNotificationViewModel();
    addTearDown(viewModel.dispose);
    final launchCompleter = Completer<void>();
    var launchCount = 0;

    await pumpWidgetInApp(
      tester,
      NotificationDetailListener(
        viewModel: viewModel,
        showDetailSheet: ({required context, required notification}) {
          launchCount += 1;
          return launchCompleter.future;
        },
        child: const Scaffold(body: SizedBox.shrink()),
      ),
    );

    viewModel
      ..selectNotification(viewModel.notifications.first)
      ..selectNotification(viewModel.notifications.last);
    await tester.pump();

    expect(launchCount, 1);
    expect(viewModel.selectedNotification, viewModel.notifications.last);

    launchCompleter.complete();
    await tester.pump();

    expect(viewModel.selectedNotification, isNull);
  });
}
