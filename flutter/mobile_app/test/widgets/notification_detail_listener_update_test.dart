import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/views/widgets/notification/notification_detail_listener.dart';

import '../helpers/test_view_models.dart';
import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('clears the launching view model when widget is updated', (
    tester,
  ) async {
    final firstViewModel = await createLoadedTestNotificationViewModel();
    final secondViewModel = await createLoadedTestNotificationViewModel();
    addTearDown(firstViewModel.dispose);
    addTearDown(secondViewModel.dispose);
    final launchCompleter = Completer<void>();

    await pumpWidgetInApp(
      tester,
      NotificationDetailListener(
        viewModel: firstViewModel,
        showDetailSheet: ({required context, required notification}) {
          return launchCompleter.future;
        },
        child: const Scaffold(body: SizedBox.shrink()),
      ),
    );

    firstViewModel.selectNotification(firstViewModel.notifications.first);
    await tester.pump();

    secondViewModel.selectNotification(secondViewModel.notifications.last);

    await pumpWidgetInApp(
      tester,
      NotificationDetailListener(
        viewModel: secondViewModel,
        showDetailSheet: ({required context, required notification}) {
          return launchCompleter.future;
        },
        child: const Scaffold(body: SizedBox.shrink()),
      ),
    );
    await tester.pump();

    launchCompleter.complete();
    await tester.pump();

    expect(firstViewModel.selectedNotification, isNull);
    expect(
      secondViewModel.selectedNotification,
      secondViewModel.notifications.last,
    );
  });

  testWidgets('shows a preselected notification after view model update', (
    tester,
  ) async {
    final firstViewModel = await createLoadedTestNotificationViewModel();
    final secondViewModel = await createLoadedTestNotificationViewModel();
    addTearDown(firstViewModel.dispose);
    addTearDown(secondViewModel.dispose);
    var launchCount = 0;
    String? launchedTitle;

    await pumpWidgetInApp(
      tester,
      NotificationDetailListener(
        viewModel: firstViewModel,
        showDetailSheet: ({required context, required notification}) {
          launchCount += 1;
          launchedTitle = notification.title;
          return Future<void>.value();
        },
        child: const Scaffold(body: SizedBox.shrink()),
      ),
    );
    await tester.pump();

    secondViewModel.selectNotification(secondViewModel.notifications.first);

    await pumpWidgetInApp(
      tester,
      NotificationDetailListener(
        viewModel: secondViewModel,
        showDetailSheet: ({required context, required notification}) {
          launchCount += 1;
          launchedTitle = notification.title;
          return Future<void>.value();
        },
        child: const Scaffold(body: SizedBox.shrink()),
      ),
    );
    await tester.pump();

    expect(launchCount, 1);
    expect(launchedTitle, secondViewModel.notifications.first.title);
  });
}
