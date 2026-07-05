import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/app_screen.dart';
import 'package:mobile_app/views/widgets/navigation/home_screen_app_bar.dart';
import 'package:mobile_app/views/widgets/navigation/screen_destination.dart';

void main() {
  testWidgets('renders destination title and color', (tester) async {
    const destination = ScreenDestination(
      screen: AppScreen.search,
      title: '検索',
      description: '検索画面',
      icon: Icons.search,
      color: Colors.indigo,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(appBar: HomeScreenAppBar(destination: destination)),
      ),
    );

    final appBar = tester.widget<AppBar>(find.byType(AppBar));

    expect(find.text('検索'), findsOneWidget);
    expect(appBar.backgroundColor, Colors.indigo.withValues(alpha: 0.16));
  });
}
