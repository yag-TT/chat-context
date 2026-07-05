import 'package:flutter/material.dart';

import '../../../models/iot_control_state.dart';
import '../common/padded_sliver_box.dart';
import '../common/screen_surface.dart';
import 'iot_control_actions.dart';
import 'iot_device_control_section.dart';
import 'iot_header_section.dart';
import 'iot_styles.dart';

/// IoT操作画面のスクロール構造と主要セクション配置を担当します。
class IotControlContent extends StatelessWidget {
  const IotControlContent({
    super.key,
    required this.state,
    required this.actions,
  });

  final IotControlState state;
  final IotControlActions actions;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [IotControlContent] ::build() - UIを描画します');
    return ScreenSurface(
      decoration: iotBackgroundDecoration,
      child: CustomScrollView(
        slivers: [
          PaddedSliverBox(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: IotHeaderSection(
              isHomeOnline: state.isHomeOnline,
              onOnlineChanged: actions.onHomeOnlineChanged,
            ),
          ),
          IotDeviceControlSection(state: state, actions: actions),
        ],
      ),
    );
  }
}
