import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/views/widgets/common/spaced_sliver_list.dart';

void main() {
  testWidgets('inserts spacing between children and footer spacing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomScrollView(
          slivers: [
            SpacedSliverList(
              spacing: 8,
              bottomSpacing: 24,
              children: [Text('first'), Text('second')],
            ),
          ],
        ),
      ),
    );

    expect(find.text('first'), findsOneWidget);
    expect(find.text('second'), findsOneWidget);
    expect(
      tester.widgetList<SizedBox>(find.byType(SizedBox)).map((box) {
        return box.height;
      }),
      containsAllInOrder([8, 24]),
    );
  });
}
