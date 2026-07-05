import '../models/settings_state.dart';
import 'base_view_model.dart';
import 'package:flutter/foundation.dart';

/// 設定画面のON/OFF項目と更新間隔を管理します。
class SettingsViewModel extends BaseViewModel {
  SettingsState _state = SettingsState();

  SettingsState get state {
    debugPrint('[DBG] [SettingsViewModel] ::state() - 現在の状態を参照します');
    return _state;
  }

  void setWeatherAlertEnabled(bool value) {
    debugPrint(
      '[DBG] [SettingsViewModel] ::setWeatherAlertEnabled() - 設定値を更新します',
    );
    _updateState(_state.copyWith(isWeatherAlertEnabled: value));
  }

  void setDeviceAutomationEnabled(bool value) {
    debugPrint(
      '[DBG] [SettingsViewModel] ::setDeviceAutomationEnabled() - 設定値を更新します',
    );
    _updateState(_state.copyWith(isDeviceAutomationEnabled: value));
  }

  void setDarkModePreviewEnabled(bool value) {
    debugPrint(
      '[DBG] [SettingsViewModel] ::setDarkModePreviewEnabled() - 設定値を更新します',
    );
    _updateState(_state.copyWith(isDarkModePreviewEnabled: value));
  }

  void setRefreshIntervalMinutes(int value) {
    debugPrint(
      '[DBG] [SettingsViewModel] ::setRefreshIntervalMinutes() - 設定値を更新します',
    );
    _updateState(_state.copyWith(refreshIntervalMinutes: value));
  }

  void _updateState(SettingsState nextState) {
    debugPrint('[DBG] [SettingsViewModel] ::_updateState() - 状態更新処理を実行します');
    // SettingsStateの正規化と等価比較を通して、無効値と不要通知を抑えます。
    updateValue(_state, nextState, (value) {
      debugPrint(
        '[DBG] [SettingsViewModel] ::updateValue() - 値の変化を確認して状態を更新します',
      );
      _state = value;
    });
  }
}
