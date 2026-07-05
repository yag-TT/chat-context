import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/views/widgets/common/horizontal_scrollable_list.dart';

import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('renders horizontally separated items', (tester) async {
    await pumpWidgetInApp(
      tester,
      HorizontalScrollableList(
        height: 80,
        itemCount: 3,
        padding: const EdgeInsets.only(bottom: 8),
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) => Text('item $index'),
      ),
    );

    expect(find.byType(Scrollbar), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('item 0'), findsOneWidget);
    expect(find.text('item 1'), findsOneWidget);
    expect(find.text('item 2'), findsOneWidget);
  });
}
