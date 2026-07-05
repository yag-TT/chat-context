import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_view_models.dart';

void main() {
  test('loadWeather stores mock weather', () async {
    final viewModel = createTestWeatherViewModel();
    addTearDown(viewModel.dispose);

    expect(viewModel.weather, isNull);
    expect(viewModel.isLoading, isFalse);

    await viewModel.loadWeather();

    expect(viewModel.weather?.city, '東京');
    expect(viewModel.errorMessage, isNull);
  });
}
