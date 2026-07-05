import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/views/widgets/common/responsive_wrap_grid.dart';

import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('uses two columns after breakpoint', (tester) async {
    await pumpWidgetInApp(
      tester,
      const Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 600,
          child: ResponsiveWrapGrid(
            children: [
              SizedBox(key: Key('first'), height: 20),
              SizedBox(key: Key('second'), height: 20),
            ],
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(const Key('first'))).width, 294);
    expect(tester.getTopLeft(find.byKey(const Key('second'))).dx, 306);
  });

  testWidgets('uses one column before breakpoint', (tester) async {
    await pumpWidgetInApp(
      tester,
      const Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 320,
          child: ResponsiveWrapGrid(
            children: [
              SizedBox(key: Key('first'), height: 20),
              SizedBox(key: Key('second'), height: 20),
            ],
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byKey(const Key('first'))).width, 320);
    expect(tester.getTopLeft(find.byKey(const Key('second'))).dy, 32);
  });
}
