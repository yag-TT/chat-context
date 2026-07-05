import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/views/widgets/common/screen_surface.dart';

void main() {
  testWidgets('wraps content with decoration and safe area by default', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ScreenSurface(
          decoration: BoxDecoration(color: Colors.red),
          child: Text('content'),
        ),
      ),
    );

    expect(find.byType(DecoratedBox), findsOneWidget);
    expect(find.byType(SafeArea), findsOneWidget);
    expect(find.text('content'), findsOneWidget);
  });

  testWidgets('can render without safe area', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ScreenSurface(
          decoration: BoxDecoration(color: Colors.red),
          useSafeArea: false,
          child: Text('content'),
        ),
      ),
    );

    expect(find.byType(SafeArea), findsNothing);
    expect(find.text('content'), findsOneWidget);
  });
}
