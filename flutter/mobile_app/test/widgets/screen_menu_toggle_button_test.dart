import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/views/widgets/navigation/screen_menu_toggle_button.dart';

void main() {
  testWidgets('shows apps icon when menu is closed and calls callback', (
    tester,
  ) async {
    var tapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          floatingActionButton: ScreenMenuToggleButton(
            isMenuOpen: false,
            onPressed: () {
              tapCount += 1;
            },
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.apps), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);

    await tester.tap(find.byType(FloatingActionButton));

    expect(tapCount, 1);
  });

  testWidgets('shows close icon when menu is open', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          floatingActionButton: ScreenMenuToggleButton(
            isMenuOpen: true,
            onPressed: _noop,
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.byIcon(Icons.apps), findsNothing);
  });
}

void _noop() {}
