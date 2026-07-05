import 'package:flutter/material.dart';

import '../../../models/fan_mode.dart';
import 'climate_fan_mode_selector.dart';
import 'climate_temperature_slider.dart';
import 'iot_panel.dart';
import 'iot_panel_header.dart';
import 'iot_styles.dart';

class IotClimateControlCard extends StatelessWidget {
  const IotClimateControlCard({
    super.key,
    required this.temperature,
    required this.fanMode,
    required this.onTemperatureChanged,
    required this.onFanModeChanged,
  });

  final double temperature;
  final FanMode fanMode;
  final ValueChanged<double> onTemperatureChanged;
  final ValueChanged<FanMode> onFanModeChanged;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [IotClimateControlCard] ::build() - UIを描画します');
    return IotPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IotPanelHeader(
            icon: Icons.thermostat_rounded,
            iconColor: Colors.deepOrange,
            title: 'スマート空調',
            subtitle: '設定温度 ${temperature.toStringAsFixed(1)}°',
            trailing: Text(
              '${temperature.toStringAsFixed(1)}°',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: iotTextPrimaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ClimateTemperatureSlider(
            value: temperature,
            onChanged: onTemperatureChanged,
          ),
          const SizedBox(height: 8),
          ClimateFanModeSelector(
            selectedMode: fanMode,
            onChanged: onFanModeChanged,
          ),
        ],
      ),
    );
  }
}
