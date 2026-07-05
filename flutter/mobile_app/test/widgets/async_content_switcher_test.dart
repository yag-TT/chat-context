import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/views/widgets/common/async_content_status_config.dart';
import 'package:mobile_app/views/widgets/common/async_content_switcher.dart';
import 'package:mobile_app/views/widgets/common/status_content_style.dart';

import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('shows data content when data is available', (tester) async {
    await pumpWidgetInApp(
      tester,
      AsyncContentSwitcher<String>(
        data: 'loaded',
        dataBuilder: (context, data) => Text(data),
        errorMessage: 'error',
        statusConfig: _statusConfig,
      ),
    );

    expect(find.text('loaded'), findsOneWidget);
    expect(find.text('error'), findsNothing);
    expect(find.text('loading'), findsNothing);
  });

  testWidgets('shows error content when data is unavailable and error exists', (
    tester,
  ) async {
    await pumpWidgetInApp(
      tester,
      AsyncContentSwitcher<String>(
        data: null,
        dataBuilder: (context, data) => Text(data),
        errorMessage: 'error',
        statusConfig: _statusConfig,
      ),
    );

    expect(find.text('error'), findsOneWidget);
    expect(find.text('loading'), findsNothing);
  });

  testWidgets('shows loading content when data and error are absent', (
    tester,
  ) async {
    await pumpWidgetInApp(
      tester,
      AsyncContentSwitcher<String>(
        data: null,
        dataBuilder: (context, data) => Text(data),
        errorMessage: null,
        statusConfig: _statusConfig,
      ),
    );

    expect(find.text('loading'), findsOneWidget);
  });
}

final _style = StatusContentStyle(
  decoration: const BoxDecoration(color: Colors.white),
  iconColor: Colors.black,
  titleColor: Colors.black,
);

final _statusConfig = AsyncContentStatusConfig(
  errorIcon: Icons.error,
  loadingIcon: Icons.sync,
  loadingTitle: 'loading',
  style: _style,
  onRetryPressed: _noop,
);

void _noop() {}
