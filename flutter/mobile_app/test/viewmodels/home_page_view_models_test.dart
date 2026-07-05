import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/app_dependencies.dart';
import 'package:mobile_app/viewmodels/home_page_view_models.dart';

void main() {
  test('creates and disposes page view models', () {
    final viewModels = HomePageViewModels(dependencies: AppDependencies.mock());

    expect(viewModels.home.isDisposed, isFalse);
    expect(viewModels.weather.isDisposed, isFalse);
    expect(viewModels.iotControl.isDisposed, isFalse);
    expect(viewModels.notifications.isDisposed, isFalse);
    expect(viewModels.settings.isDisposed, isFalse);
    expect(viewModels.isDisposed, isFalse);

    viewModels.dispose();

    expect(viewModels.isDisposed, isTrue);
    expect(viewModels.home.isDisposed, isTrue);
    expect(viewModels.weather.isDisposed, isTrue);
    expect(viewModels.iotControl.isDisposed, isTrue);
    expect(viewModels.notifications.isDisposed, isTrue);
    expect(viewModels.settings.isDisposed, isTrue);
  });

  test('dispose can be called more than once', () {
    final viewModels = HomePageViewModels(dependencies: AppDependencies.mock());

    viewModels
      ..dispose()
      ..dispose();

    expect(viewModels.isDisposed, isTrue);
  });

  test('loadInitialData loads repository backed view models', () async {
    final viewModels = HomePageViewModels(dependencies: AppDependencies.mock());
    addTearDown(viewModels.dispose);

    expect(viewModels.weather.weather, isNull);
    expect(viewModels.iotControl.state.sensorReadings, isEmpty);
    expect(viewModels.notifications.notifications, isEmpty);

    await viewModels.loadInitialData();

    expect(viewModels.weather.weather?.city, '東京');
    expect(viewModels.iotControl.state.sensorReadings, hasLength(3));
    expect(viewModels.notifications.notifications, hasLength(4));
  });

  test('loadInitialData does nothing after dispose', () async {
    final viewModels = HomePageViewModels(dependencies: AppDependencies.mock());

    viewModels.dispose();
    await viewModels.loadInitialData();

    expect(viewModels.weather.weather, isNull);
    expect(viewModels.iotControl.state.sensorReadings, isEmpty);
    expect(viewModels.notifications.notifications, isEmpty);
  });
}
