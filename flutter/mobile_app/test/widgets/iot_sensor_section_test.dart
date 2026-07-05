import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/mock_data/mock_iot_sensor_data.dart';
import 'package:mobile_app/views/widgets/iot/iot_sensor_section.dart';

import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('renders injected IoT sensor readings', (tester) async {
    await pumpWidgetInApp(
      tester,
      IotSensorSection(
        readings: mockIotSensorReadings.take(2).toList(),
        hasLoadedReadings: true,
      ),
    );

    expect(find.text('センサー'), findsOneWidget);
    expect(find.text('湿度'), findsOneWidget);
    expect(find.text('48%'), findsOneWidget);
    expect(find.text('CO2'), findsOneWidget);
    expect(find.text('612 ppm'), findsOneWidget);
    expect(find.text('窓'), findsNothing);
  });

  testWidgets('shows loading text before sensor readings are loaded', (
    tester,
  ) async {
    await pumpWidgetInApp(
      tester,
      const IotSensorSection(readings: [], hasLoadedReadings: false),
    );

    expect(find.text('センサー情報を読み込み中'), findsOneWidget);
  });

  testWidgets('shows empty text after empty sensor readings are loaded', (
    tester,
  ) async {
    await pumpWidgetInApp(
      tester,
      const IotSensorSection(readings: [], hasLoadedReadings: true),
    );

    expect(find.text('センサー情報はありません'), findsOneWidget);
  });
}
