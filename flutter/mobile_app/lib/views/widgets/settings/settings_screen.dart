import 'package:flutter/material.dart';

import '../../../viewmodels/settings_view_model.dart';
import '../common/view_model_builder.dart';
import 'settings_actions.dart';
import 'settings_content.dart';

/// SettingsViewModelを監視し、設定状態と操作コールバックを画面へ渡します。
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [SettingsScreen] ::build() - 画面を描画します');
    return ViewModelBuilder(
      viewModel: viewModel,
      builder: (context, viewModel) {
        return SettingsContent(
          state: viewModel.state,
          actions: SettingsActions.fromViewModel(viewModel),
        );
      },
    );
  }
}
