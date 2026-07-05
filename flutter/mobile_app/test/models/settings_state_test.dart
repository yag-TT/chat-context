import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/settings_state.dart';

void main() {
  test('copyWith updates selected settings fields', () {
    final state = SettingsState().copyWith(
      isWeatherAlertEnabled: false,
      isDarkModePreviewEnabled: true,
      refreshIntervalMinutes: 30,
    );

    expect(state.isWeatherAlertEnabled, isFalse);
    expect(state.isDeviceAutomationEnabled, isTrue);
    expect(state.isDarkModePreviewEnabled, isTrue);
    expect(state.refreshIntervalMinutes, 30);
  });

  test('states with same values are equal', () {
    expect(SettingsState(), SettingsState());
  });

  test('constructor normalizes refresh interval to supported range', () {
    expect(
      SettingsState(
        refreshIntervalMinutes: settingsMaxRefreshIntervalMinutes + 1,
      ).refreshIntervalMinutes,
      settingsMaxRefreshIntervalMinutes,
    );
    expect(
      SettingsState(
        refreshIntervalMinutes: settingsMinRefreshIntervalMinutes - 1,
      ).refreshIntervalMinutes,
      settingsMinRefreshIntervalMinutes,
    );
  });

  test('normalizes refresh interval to supported range', () {
    expect(
      normalizeRefreshIntervalMinutes(settingsMaxRefreshIntervalMinutes + 1),
      settingsMaxRefreshIntervalMinutes,
    );
    expect(
      normalizeRefreshIntervalMinutes(settingsMinRefreshIntervalMinutes - 1),
      settingsMinRefreshIntervalMinutes,
    );
  });
}
