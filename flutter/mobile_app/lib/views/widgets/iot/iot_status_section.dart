import 'package:flutter/material.dart';

import 'iot_metric_tile.dart';

class IotStatusSection extends StatelessWidget {
  const IotStatusSection({super.key, required this.isHomeOnline});

  final bool isHomeOnline;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [IotStatusSection] ::build() - UIを描画します');
    return Row(
      children: [
        Expanded(
          child: IotMetricTile(
            icon: Icons.hub_rounded,
            label: '状態',
            value: isHomeOnline ? 'オンライン' : 'オフライン',
            color: isHomeOnline ? Colors.teal : Colors.grey,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: IotMetricTile(
            icon: Icons.speed_rounded,
            label: '通信',
            value: '18 ms',
            color: Colors.indigo,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: IotMetricTile(
            icon: Icons.bolt_rounded,
            label: '電力',
            value: '1.8 kW',
            color: Colors.amber,
          ),
        ),
      ],
    );
  }
}
