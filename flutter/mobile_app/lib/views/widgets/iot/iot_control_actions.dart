import 'package:flutter/material.dart';

import '../../../models/fan_mode.dart';
import '../../../viewmodels/iot_control_view_model.dart';

class IotControlActions {
  const IotControlActions({
    required this.onHomeOnlineChanged,
    required this.onLivingLightChanged,
    required this.onLightBrightnessChanged,
    required this.onTargetTemperatureChanged,
    required this.onFanModeChanged,
    required this.onEntranceLockedChanged,
    required this.onAirPurifierChanged,
  });

  factory IotControlActions.fromViewModel(IotControlViewModel viewModel) {
    return IotControlActions(
      onHomeOnlineChanged: viewModel.setHomeOnline,
      onLivingLightChanged: viewModel.setLivingLightOn,
      onLightBrightnessChanged: viewModel.setLightBrightness,
      onTargetTemperatureChanged: viewModel.setTargetTemperature,
      onFanModeChanged: viewModel.setFanMode,
      onEntranceLockedChanged: viewModel.setEntranceLocked,
      onAirPurifierChanged: viewModel.setAirPurifierOn,
    );
  }

  final ValueChanged<bool> onHomeOnlineChanged;
  final ValueChanged<bool> onLivingLightChanged;
  final ValueChanged<double> onLightBrightnessChanged;
  final ValueChanged<double> onTargetTemperatureChanged;
  final ValueChanged<FanMode> onFanModeChanged;
  final ValueChanged<bool> onEntranceLockedChanged;
  final ValueChanged<bool> onAirPurifierChanged;
}
