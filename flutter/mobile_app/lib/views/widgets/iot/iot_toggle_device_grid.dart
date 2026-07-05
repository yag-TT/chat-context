import 'package:flutter/material.dart';

import 'iot_toggle_device_card.dart';
import '../common/responsive_wrap_grid.dart';

class IotToggleDeviceGrid extends StatelessWidget {
  const IotToggleDeviceGrid({
    super.key,
    required this.isEntranceLocked,
    required this.isAirPurifierOn,
    required this.onEntranceLockedChanged,
    required this.onAirPurifierChanged,
  });

  final bool isEntranceLocked;
  final bool isAirPurifierOn;
  final ValueChanged<bool> onEntranceLockedChanged;
  final ValueChanged<bool> onAirPurifierChanged;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [IotToggleDeviceGrid] ::build() - UIを描画します');
    return ResponsiveWrapGrid(
      children: [
        IotToggleDeviceCard(
          icon: Icons.lock_rounded,
          title: '玄関ロック',
          subtitle: isEntranceLocked ? '施錠中' : '解錠中',
          color: Colors.blueGrey,
          value: isEntranceLocked,
          onChanged: onEntranceLockedChanged,
        ),
        IotToggleDeviceCard(
          icon: Icons.air_rounded,
          title: '空気清浄機',
          subtitle: isAirPurifierOn ? '運転中' : '停止中',
          color: Colors.teal,
          value: isAirPurifierOn,
          onChanged: onAirPurifierChanged,
        ),
      ],
    );
  }
}
