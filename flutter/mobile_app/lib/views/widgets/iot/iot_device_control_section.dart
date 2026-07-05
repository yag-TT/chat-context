import 'package:flutter/material.dart';

import '../../../models/iot_control_state.dart';
import '../common/spaced_sliver_list.dart';
import 'iot_climate_control_card.dart';
import 'iot_control_actions.dart';
import 'iot_light_control_card.dart';
import 'iot_sensor_section.dart';
import 'iot_status_section.dart';
import 'iot_toggle_device_grid.dart';

class IotDeviceControlSection extends StatelessWidget {
  const IotDeviceControlSection({
    super.key,
    required this.state,
    required this.actions,
  });

  final IotControlState state;
  final IotControlActions actions;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [IotDeviceControlSection] ::build() - UIを描画します');
    return SpacedSliverList(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      bottomSpacing: 96,
      children: [
        IotStatusSection(isHomeOnline: state.isHomeOnline),
        IotLightControlCard(
          isOn: state.isLivingLightOn,
          brightness: state.lightBrightness,
          onPowerChanged: actions.onLivingLightChanged,
          onBrightnessChanged: state.isLivingLightOn
              ? actions.onLightBrightnessChanged
              : null,
        ),
        IotClimateControlCard(
          temperature: state.targetTemperature,
          fanMode: state.fanMode,
          onTemperatureChanged: actions.onTargetTemperatureChanged,
          onFanModeChanged: actions.onFanModeChanged,
        ),
        IotToggleDeviceGrid(
          isEntranceLocked: state.isEntranceLocked,
          isAirPurifierOn: state.isAirPurifierOn,
          onEntranceLockedChanged: actions.onEntranceLockedChanged,
          onAirPurifierChanged: actions.onAirPurifierChanged,
        ),
        IotSensorSection(
          readings: state.sensorReadings,
          hasLoadedReadings: state.hasLoadedSensorReadings,
        ),
      ],
    );
  }
}
