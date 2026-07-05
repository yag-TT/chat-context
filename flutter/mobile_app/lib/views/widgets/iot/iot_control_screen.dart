import 'package:flutter/material.dart';

import '../../../viewmodels/iot_control_view_model.dart';
import '../common/view_model_builder.dart';
import 'iot_control_actions.dart';
import 'iot_control_content.dart';

/// IotControlViewModelを監視し、状態と操作コールバックを画面へ渡します。
class IotControlScreen extends StatelessWidget {
  const IotControlScreen({super.key, required this.viewModel});

  final IotControlViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [IotControlScreen] ::build() - 画面を描画します');
    return ViewModelBuilder(
      viewModel: viewModel,
      builder: (context, viewModel) {
        return IotControlContent(
          state: viewModel.state,
          actions: IotControlActions.fromViewModel(viewModel),
        );
      },
    );
  }
}
