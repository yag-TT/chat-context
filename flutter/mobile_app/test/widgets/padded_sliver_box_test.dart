import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/views/widgets/common/padded_sliver_box.dart';

void main() {
  testWidgets('renders a padded box inside a sliver', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomScrollView(
          slivers: [
            PaddedSliverBox(
              padding: EdgeInsets.all(12),
              child: Text('content'),
            ),
          ],
        ),
      ),
    );

    expect(find.text('content'), findsOneWidget);
    expect(find.byType(SliverPadding), findsOneWidget);
    expect(find.byType(SliverToBoxAdapter), findsOneWidget);
  });
}
