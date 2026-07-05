import 'package:flutter/foundation.dart';

const settingsDefaultRefreshIntervalMinutes = 15;
const settingsMinRefreshIntervalMinutes = 5;
const settingsMaxRefreshIntervalMinutes = 60;
const settingsRefreshIntervalStepMinutes = 5;
const settingsRefreshIntervalDivisions =
    (settingsMaxRefreshIntervalMinutes - settingsMinRefreshIntervalMinutes) ~/
    settingsRefreshIntervalStepMinutes;

/// 設定画面の更新間隔をサポート範囲内に丸めます。
int normalizeRefreshIntervalMinutes(int minutes) {
  debugPrint(
    '[DBG] [Global] ::normalizeRefreshIntervalMinutes() - 更新間隔を有効範囲に丸めます',
  );
  return minutes
      .clamp(
        settingsMinRefreshIntervalMinutes,
        settingsMaxRefreshIntervalMinutes,
      )
      .toInt();
}

/// 設定画面で操作する値をまとめた状態です。
///
/// 更新間隔はコンストラクタで正規化し、範囲外の値を保持しないようにします。
class SettingsState {
  SettingsState({
    this.isWeatherAlertEnabled = true,
    this.isDeviceAutomationEnabled = true,
    this.isDarkModePreviewEnabled = false,
    int refreshIntervalMinutes = settingsDefaultRefreshIntervalMinutes,
  }) : refreshIntervalMinutes = normalizeRefreshIntervalMinutes(
         refreshIntervalMinutes,
       );

  final bool isWeatherAlertEnabled;
  final bool isDeviceAutomationEnabled;
  final bool isDarkModePreviewEnabled;
  final int refreshIntervalMinutes;

  SettingsState copyWith({
    bool? isWeatherAlertEnabled,
    bool? isDeviceAutomationEnabled,
    bool? isDarkModePreviewEnabled,
    int? refreshIntervalMinutes,
  }) {
    debugPrint('[DBG] [SettingsState] ::copyWith() - 変更後の状態を作成します');
    return SettingsState(
      isWeatherAlertEnabled:
          isWeatherAlertEnabled ?? this.isWeatherAlertEnabled,
      isDeviceAutomationEnabled:
          isDeviceAutomationEnabled ?? this.isDeviceAutomationEnabled,
      isDarkModePreviewEnabled:
          isDarkModePreviewEnabled ?? this.isDarkModePreviewEnabled,
      refreshIntervalMinutes:
          refreshIntervalMinutes ?? this.refreshIntervalMinutes,
    );
  }

  @override
  bool operator ==(Object other) {
    debugPrint('[DBG] [SettingsState] ::operator==() - 同じ値か比較します');
    return identical(this, other) ||
        other is SettingsState &&
            other.isWeatherAlertEnabled == isWeatherAlertEnabled &&
            other.isDeviceAutomationEnabled == isDeviceAutomationEnabled &&
            other.isDarkModePreviewEnabled == isDarkModePreviewEnabled &&
            other.refreshIntervalMinutes == refreshIntervalMinutes;
  }

  @override
  int get hashCode {
    debugPrint('[DBG] [SettingsState] ::hashCode() - ハッシュ値を計算します');
    return Object.hash(
      isWeatherAlertEnabled,
      isDeviceAutomationEnabled,
      isDarkModePreviewEnabled,
      refreshIntervalMinutes,
    );
  }
}
