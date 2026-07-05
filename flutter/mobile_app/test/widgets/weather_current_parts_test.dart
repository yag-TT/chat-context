import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/views/widgets/weather/weather_condition_summary.dart';
import 'package:mobile_app/views/widgets/weather/weather_temperature_display.dart';

import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('WeatherTemperatureDisplay shows temperature', (tester) async {
    await pumpWidgetInApp(
      tester,
      const WeatherTemperatureDisplay(temperature: 24),
    );

    expect(find.text('24°'), findsOneWidget);
  });

  testWidgets('WeatherConditionSummary shows condition and update label', (
    tester,
  ) async {
    await pumpWidgetInApp(
      tester,
      const WeatherConditionSummary(
        condition: '晴れ',
        highTemperature: 27,
        lowTemperature: 19,
        updatedAtLabel: '10分前に更新',
      ),
    );

    expect(find.text('晴れ'), findsOneWidget);
    expect(find.text('最高:27°  最低:19°'), findsOneWidget);
    expect(find.text('10分前に更新'), findsOneWidget);
  });
}
