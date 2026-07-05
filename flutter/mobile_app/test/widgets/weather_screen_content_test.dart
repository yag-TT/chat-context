import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/mock_data/mock_weather_data.dart';
import 'package:mobile_app/views/widgets/weather/weather_screen_content.dart';

import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('shows loading when weather and error are absent', (
    tester,
  ) async {
    await pumpWidgetInApp(
      tester,
      const WeatherScreenContent(
        weather: null,
        errorMessage: null,
        onRetryPressed: _noop,
      ),
    );

    expect(find.text('天気情報を読み込み中'), findsOneWidget);
  });

  testWidgets('shows weather when weather is present', (tester) async {
    await pumpWidgetInApp(
      tester,
      WeatherScreenContent(
        weather: mockWeatherSnapshot,
        errorMessage: 'error',
        onRetryPressed: _noop,
      ),
    );

    expect(find.text('東京'), findsOneWidget);
    expect(find.text('error'), findsNothing);
  });
}

void _noop() {}
