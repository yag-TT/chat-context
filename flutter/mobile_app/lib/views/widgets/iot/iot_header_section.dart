import 'package:flutter/material.dart';

import 'iot_styles.dart';

class IotHeaderSection extends StatelessWidget {
  const IotHeaderSection({
    super.key,
    required this.isHomeOnline,
    required this.onOnlineChanged,
  });

  final bool isHomeOnline;
  final ValueChanged<bool> onOnlineChanged;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [IotHeaderSection] ::build() - UIを描画します');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'IoT Hub',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: iotTextPrimaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'リビング / 4デバイス接続',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: iotTextSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: isHomeOnline,
          onChanged: onOnlineChanged,
          activeThumbColor: iotOnlineColor,
        ),
      ],
    );
  }
}
