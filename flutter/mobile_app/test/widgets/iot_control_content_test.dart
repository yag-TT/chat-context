import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/iot_control_state.dart';
import 'package:mobile_app/views/widgets/iot/iot_control_actions.dart';
import 'package:mobile_app/views/widgets/iot/iot_control_content.dart';

import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('renders IoT content from state and actions', (tester) async {
    await pumpWidgetInApp(
      tester,
      Scaffold(
        body: IotControlContent(
          state: IotControlState(isHomeOnline: false, isLivingLightOn: false),
          actions: _actions,
        ),
      ),
    );

    expect(find.text('IoT Hub'), findsOneWidget);
    expect(find.text('リビングライト'), findsOneWidget);
    expect(find.text('スマート空調'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('オフライン'), 120);

    expect(find.text('オフライン'), findsOneWidget);
  });
}

final _actions = IotControlActions(
  onHomeOnlineChanged: _ignoreBool,
  onLivingLightChanged: _ignoreBool,
  onLightBrightnessChanged: _ignoreDouble,
  onTargetTemperatureChanged: _ignoreDouble,
  onFanModeChanged: (_) {},
  onEntranceLockedChanged: _ignoreBool,
  onAirPurifierChanged: _ignoreBool,
);

void _ignoreBool(bool value) {}

void _ignoreDouble(double value) {}
