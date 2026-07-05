import 'package:flutter/foundation.dart';

import '../../models/iot_control_state.dart';
import 'iot_control_preferences_repository.dart';

class InMemoryIotControlPreferencesRepository
    implements IotControlPreferencesRepository {
  InMemoryIotControlPreferencesRepository({IotControlState? initialState})
    : _state = initialState == null ? null : _operationStateFrom(initialState);

  IotControlState? _state;

  @override
  Future<IotControlState?> loadState() async {
    debugPrint(
      '[DBG] [InMemoryIotControlPreferencesRepository] ::loadState() - 保存済みIoT操作設定を読み込みます',
    );
    return _state;
  }

  @override
  Future<void> saveState(IotControlState state) async {
    debugPrint(
      '[DBG] [InMemoryIotControlPreferencesRepository] ::saveState() - IoT操作設定を保存します',
    );
    _state = _operationStateFrom(state);
  }

  static IotControlState _operationStateFrom(IotControlState state) {
    debugPrint(
      '[DBG] [InMemoryIotControlPreferencesRepository] ::_operationStateFrom() - 保存対象のIoT操作設定を抽出します',
    );
    return IotControlState(
      isHomeOnline: state.isHomeOnline,
      isLivingLightOn: state.isLivingLightOn,
      isEntranceLocked: state.isEntranceLocked,
      isAirPurifierOn: state.isAirPurifierOn,
      lightBrightness: state.lightBrightness,
      targetTemperature: state.targetTemperature,
      fanMode: state.fanMode,
    );
  }
}
