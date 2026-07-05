import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/views/widgets/settings/settings_actions.dart';
import 'package:mobile_app/viewmodels/settings_view_model.dart';

void main() {
  test('fromViewModel wires callbacks to the settings view model', () {
    final viewModel = SettingsViewModel();
    addTearDown(viewModel.dispose);

    final actions = SettingsActions.fromViewModel(viewModel);

    actions
      ..onWeatherAlertChanged(false)
      ..onDeviceAutomationChanged(false)
      ..onDarkModePreviewChanged(true)
      ..onRefreshIntervalChanged(30);

    expect(viewModel.state.isWeatherAlertEnabled, isFalse);
    expect(viewModel.state.isDeviceAutomationEnabled, isFalse);
    expect(viewModel.state.isDarkModePreviewEnabled, isTrue);
    expect(viewModel.state.refreshIntervalMinutes, 30);
  });
}
