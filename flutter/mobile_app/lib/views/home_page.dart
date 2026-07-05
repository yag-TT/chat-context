import 'dart:async';

import 'package:flutter/material.dart';

import '../core/app_dependencies.dart';
import '../viewmodels/home_page_view_models.dart';
import 'widgets/navigation/home_scaffold.dart';
import 'widgets/notification/notification_detail_listener.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  // ignore: no_logic_in_create_state
  State<HomePage> createState() {
    debugPrint('[DBG] [HomePage] ::createState() - Stateを生成します');
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late HomePageViewModels _viewModels;

  @override
  void initState() {
    debugPrint('[DBG] [HomePage::HomePageState] ::initState() - 初期化処理を開始します');
    super.initState();
    _createAndLoadViewModels();
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    debugPrint(
      '[DBG] [HomePage::HomePageState] ::didUpdateWidget() - Widget更新時の状態差し替えを確認します',
    );
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dependencies == widget.dependencies) {
      return;
    }

    // Repositoryの実体が変わった場合は、古いViewModelを破棄して
    // 新しい依存で初期データを読み直します。
    _viewModels.dispose();
    _createAndLoadViewModels();
  }

  @override
  void dispose() {
    debugPrint(
      '[DBG] [HomePage::HomePageState] ::dispose() - 保持しているリソースを破棄します',
    );
    _viewModels.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [HomePage::HomePageState] ::build() - 画面を描画します');
    return NotificationDetailListener(
      viewModel: _viewModels.notifications,
      child: HomeScaffold(viewModels: _viewModels),
    );
  }

  void _createAndLoadViewModels() {
    debugPrint(
      '[DBG] [HomePage::HomePageState] ::_createAndLoadViewModels() - ViewModelを生成して初期データを読み込みます',
    );
    _viewModels = HomePageViewModels(dependencies: widget.dependencies);
    // 初期表示を止めないよう、Repositoryからの読み込みは非同期で開始します。
    unawaited(_viewModels.loadInitialData());
  }
}
