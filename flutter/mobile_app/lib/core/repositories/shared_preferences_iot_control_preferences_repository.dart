import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/fan_mode.dart';
import '../../models/iot_control_state.dart';
import 'iot_control_preferences_repository.dart';

class SharedPreferencesIotControlPreferencesRepository
    implements IotControlPreferencesRepository {
  SharedPreferencesIotControlPreferencesRepository({
    SharedPreferencesAsync? preferences,
  }) : _preferences = preferences ?? SharedPreferencesAsync();

  static const _isHomeOnlineKey = 'iot_control.is_home_online';
  static const _isLivingLightOnKey = 'iot_control.is_living_light_on';
  static const _isEntranceLockedKey = 'iot_control.is_entrance_locked';
  static const _isAirPurifierOnKey = 'iot_control.is_air_purifier_on';
  static const _lightBrightnessKey = 'iot_control.light_brightness';
  static const _targetTemperatureKey = 'iot_control.target_temperature';
  static const _fanModeKey = 'iot_control.fan_mode';

  final SharedPreferencesAsync _preferences;

  @override
  Future<IotControlState?> loadState() async {
    debugPrint(
      '[DBG] [SharedPreferencesIotControlPreferencesRepository] ::loadState() - 保存済みIoT操作設定を読み込みます',
    );
    final isHomeOnline = await _preferences.getBool(_isHomeOnlineKey);
    if (isHomeOnline == null) {
      return null;
    }

    return IotControlState(
      isHomeOnline: isHomeOnline,
      isLivingLightOn: await _preferences.getBool(_isLivingLightOnKey) ?? true,
      isEntranceLocked:
          await _preferences.getBool(_isEntranceLockedKey) ?? true,
      isAirPurifierOn: await _preferences.getBool(_isAirPurifierOnKey) ?? false,
      lightBrightness:
          await _preferences.getDouble(_lightBrightnessKey) ??
          IotControlState().lightBrightness,
      targetTemperature:
          await _preferences.getDouble(_targetTemperatureKey) ??
          IotControlState().targetTemperature,
      fanMode: _fanModeFromName(await _preferences.getString(_fanModeKey)),
    );
  }

  @override
  Future<void> saveState(IotControlState state) async {
    debugPrint(
      '[DBG] [SharedPreferencesIotControlPreferencesRepository] ::saveState() - IoT操作設定を保存します',
    );
    await Future.wait([
      _preferences.setBool(_isHomeOnlineKey, state.isHomeOnline),
      _preferences.setBool(_isLivingLightOnKey, state.isLivingLightOn),
      _preferences.setBool(_isEntranceLockedKey, state.isEntranceLocked),
      _preferences.setBool(_isAirPurifierOnKey, state.isAirPurifierOn),
      _preferences.setDouble(_lightBrightnessKey, state.lightBrightness),
      _preferences.setDouble(_targetTemperatureKey, state.targetTemperature),
      _preferences.setString(_fanModeKey, state.fanMode.name),
    ]);
  }

  static FanMode _fanModeFromName(String? name) {
    debugPrint(
      '[DBG] [SharedPreferencesIotControlPreferencesRepository] ::_fanModeFromName() - 保存値から送風モードを復元します',
    );
    return FanMode.values.firstWhere(
      (mode) => mode.name == name,
      orElse: () => FanMode.auto,
    );
  }
}
