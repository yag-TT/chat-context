import 'package:flutter/material.dart';

import '../../../models/iot_sensor_reading.dart';
import 'iot_panel.dart';
import 'iot_sensor_chip.dart';
import 'iot_styles.dart';

class IotSensorSection extends StatelessWidget {
  const IotSensorSection({
    super.key,
    required this.readings,
    required this.hasLoadedReadings,
  });

  final List<IotSensorReading> readings;
  final bool hasLoadedReadings;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [IotSensorSection] ::build() - UIを描画します');
    final statusMessage = hasLoadedReadings ? 'センサー情報はありません' : 'センサー情報を読み込み中';

    return IotPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'センサー',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: iotTextPrimaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          if (readings.isEmpty)
            Text(
              statusMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: iotTextSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final reading in readings)
                  IotSensorChip(
                    icon: reading.icon,
                    label: reading.label,
                    value: reading.value,
                    color: reading.color,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
