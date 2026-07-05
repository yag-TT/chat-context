import 'dart:async';

import '../core/repositories/iot_control_preferences_repository.dart';
import '../core/repositories/iot_sensor_repository.dart';
import '../models/fan_mode.dart';
import '../models/iot_control_state.dart';
import 'async_view_model.dart';
import 'package:flutter/foundation.dart';

/// IoT操作画面の表示状態とユーザー操作を管理します。
///
/// センサー表示データはRepositoryから取得し、照明や空調などの操作状態は
/// [IotControlState] としてまとめて保持します。
class IotControlViewModel extends AsyncViewModel {
  IotControlViewModel({
    required IotSensorRepository iotSensorRepository,
    required IotControlPreferencesRepository iotControlPreferencesRepository,
    IotControlState? initialState,
  }) : _iotSensorRepository = iotSensorRepository,
       _iotControlPreferencesRepository = iotControlPreferencesRepository,
       _state = initialState ?? IotControlState();

  final IotSensorRepository _iotSensorRepository;
  final IotControlPreferencesRepository _iotControlPreferencesRepository;
  IotControlState _state;

  IotControlState get state {
    debugPrint('[DBG] [IotControlViewModel] ::state() - 現在の状態を参照します');
    return _state;
  }

  Future<void> loadInitialData() async {
    debugPrint(
      '[DBG] [IotControlViewModel] ::loadInitialData() - 保存済み設定とセンサー情報を読み込みます',
    );
    await runLoad(
      errorMessage: 'IoT情報を取得できませんでした。',
      load: () async {
        final savedState = await _iotControlPreferencesRepository.loadState();
        if (savedState != null) {
          _state = _state.copyWith(
            isHomeOnline: savedState.isHomeOnline,
            isLivingLightOn: savedState.isLivingLightOn,
            isEntranceLocked: savedState.isEntranceLocked,
            isAirPurifierOn: savedState.isAirPurifierOn,
            lightBrightness: savedState.lightBrightness,
            targetTemperature: savedState.targetTemperature,
            fanMode: savedState.fanMode,
          );
        }

        final sensorReadings = await _iotSensorRepository.fetchSensorReadings();
        _state = _state.withLoadedSensorReadings(sensorReadings);
      },
    );
  }

  Future<void> loadSensorReadings() async {
    debugPrint(
      '[DBG] [IotControlViewModel] ::loadSensorReadings() - センサー情報を読み込みます',
    );
    await runLoadValue(
      errorMessage: 'センサー情報を取得できませんでした。',
      load: _iotSensorRepository.fetchSensorReadings,
      onData: (sensorReadings) {
        _state = _state.withLoadedSensorReadings(sensorReadings);
      },
    );
  }

  void setHomeOnline(bool value) {
    debugPrint('[DBG] [IotControlViewModel] ::setHomeOnline() - 設定値を更新します');
    _updateState(_state.copyWith(isHomeOnline: value));
  }

  void setLivingLightOn(bool value) {
    debugPrint('[DBG] [IotControlViewModel] ::setLivingLightOn() - 設定値を更新します');
    _updateState(_state.copyWith(isLivingLightOn: value));
  }

  void setEntranceLocked(bool value) {
    debugPrint('[DBG] [IotControlViewModel] ::setEntranceLocked() - 設定値を更新します');
    _updateState(_state.copyWith(isEntranceLocked: value));
  }

  void setAirPurifierOn(bool value) {
    debugPrint('[DBG] [IotControlViewModel] ::setAirPurifierOn() - 設定値を更新します');
    _updateState(_state.copyWith(isAirPurifierOn: value));
  }

  void setLightBrightness(double value) {
    debugPrint(
      '[DBG] [IotControlViewModel] ::setLightBrightness() - 設定値を更新します',
    );
    _updateState(_state.copyWith(lightBrightness: value));
  }

  void setTargetTemperature(double value) {
    debugPrint(
      '[DBG] [IotControlViewModel] ::setTargetTemperature() - 設定値を更新します',
    );
    _updateState(_state.copyWith(targetTemperature: value));
  }

  void setFanMode(FanMode value) {
    debugPrint('[DBG] [IotControlViewModel] ::setFanMode() - 設定値を更新します');
    _updateState(_state.copyWith(fanMode: value));
  }

  void _updateState(IotControlState nextState) {
    debugPrint('[DBG] [IotControlViewModel] ::_updateState() - 状態更新処理を実行します');
    // IotControlStateの等価比較により、同じ値への更新では再描画しません。
    final previousState = _state;
    updateValue(_state, nextState, (value) {
      debugPrint(
        '[DBG] [IotControlViewModel] ::updateValue() - 値の変化を確認して状態を更新します',
      );
      _state = value;
    });
    if (_state != previousState) {
      unawaited(_saveControlState());
    }
  }

  Future<void> _saveControlState() async {
    debugPrint(
      '[DBG] [IotControlViewModel] ::_saveControlState() - IoT操作設定を保存します',
    );
    try {
      await _iotControlPreferencesRepository.saveState(_state);
    } on Exception catch (error) {
      debugPrint(
        '[DBG] [IotControlViewModel] ::_saveControlState() - IoT操作設定の保存に失敗しました: $error',
      );
    }
  }
}
