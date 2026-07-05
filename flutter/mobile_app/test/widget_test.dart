// Flutter の基本的なウィジェットテストです。
// WidgetTester を使って画面操作を再現し、表示内容の変化を検証します。

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_app/core/app_dependencies.dart';
import 'package:mobile_app/main.dart';

void main() {
  testWidgets('右下ボタンから4画面を切り替えられる', (WidgetTester tester) async {
    // テスト対象のアプリを描画します。
    await tester.pumpWidget(MyApp(dependencies: AppDependencies.mock()));
    await tester.pumpAndSettle();

    // 初期状態では天気のホーム画面が表示されます。
    expect(find.text('東京'), findsOneWidget);
    expect(find.text('24°'), findsWidgets);
    expect(find.text('時間ごとの予報'), findsOneWidget);
    expect(find.text('検索'), findsNothing);

    // 右下のボタンを押すと、画面切り替え用の4つのボタンが表示されます。
    await tester.tap(find.byIcon(Icons.apps));
    await tester.pumpAndSettle();

    expect(find.text('ホーム画面'), findsOneWidget);
    expect(find.text('検索'), findsOneWidget);
    expect(find.text('通知'), findsOneWidget);
    expect(find.text('設定'), findsOneWidget);

    // 検索ボタンを押すと、IoT操作画面が表示されます。
    await tester.tap(find.text('検索'));
    await tester.pumpAndSettle();

    expect(find.text('IoT Hub'), findsOneWidget);
    expect(find.text('リビングライト'), findsOneWidget);
    expect(find.text('スマート空調'), findsOneWidget);

    await tester.tap(find.byType(Switch).at(1));
    await tester.pumpAndSettle();

    expect(find.text('オフ'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.apps));
    await tester.pumpAndSettle();

    // 通知ボタンを押すと、Repositoryから取得したモック通知が表示されます。
    await tester.tap(find.text('通知'));
    await tester.pumpAndSettle();

    expect(find.text('雨雲が近づいています'), findsOneWidget);
    expect(find.text('未読の通知が2件あります'), findsOneWidget);

    await tester.tap(find.text('雨雲が近づいています'));
    await tester.pumpAndSettle();

    expect(find.text('確認しました'), findsOneWidget);

    await tester.tap(find.text('確認しました'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.apps));
    await tester.pumpAndSettle();

    // 検索画面へ戻ると、IoT操作状態が保持されています。
    await tester.tap(find.text('検索'));
    await tester.pumpAndSettle();

    expect(find.text('オフ'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.apps));
    await tester.pumpAndSettle();

    // 設定ボタンを押すと、表示中の画面が設定に切り替わります。
    await tester.tap(find.text('設定'));
    await tester.pumpAndSettle();

    expect(find.text('通知設定'), findsOneWidget);
    expect(find.text('天気アラート'), findsOneWidget);
    expect(find.text('IoT自動制御'), findsOneWidget);
    expect(find.text('データ更新間隔'), findsOneWidget);
    expect(find.byIcon(Icons.apps), findsOneWidget);
  });
}
