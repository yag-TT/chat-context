import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/views/widgets/weather/weather_daily_temperature_summary.dart';

import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('shows low and high temperatures', (tester) async {
    await pumpWidgetInApp(
      tester,
      const WeatherDailyTemperatureSummary(
        lowTemperature: 19,
        highTemperature: 27,
      ),
    );

    expect(find.text('19°'), findsOneWidget);
    expect(find.text('27°'), findsOneWidget);
  });
}
