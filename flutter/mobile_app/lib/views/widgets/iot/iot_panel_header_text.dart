import 'package:flutter/material.dart';

import 'iot_styles.dart';

class IotPanelHeaderText extends StatelessWidget {
  const IotPanelHeaderText({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [IotPanelHeaderText] ::build() - UIを描画します');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: iotTextPrimaryColor,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: iotTextSecondaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
