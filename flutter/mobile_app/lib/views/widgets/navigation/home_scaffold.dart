import 'package:flutter/material.dart';

import '../../../models/app_screen.dart';
import '../../../viewmodels/home_page_view_models.dart';
import '../common/view_model_builder.dart';
import 'expandable_screen_menu.dart';
import 'home_screen_app_bar.dart';
import 'home_screen_body.dart';
import 'screen_destinations.dart';

/// 選択中画面に応じてAppBar、本文、画面切り替えメニューを組み立てます。
class HomeScaffold extends StatelessWidget {
  const HomeScaffold({super.key, required this.viewModels});

  final HomePageViewModels viewModels;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [HomeScaffold] ::build() - UIを描画します');
    return ViewModelBuilder(
      viewModel: viewModels.home,
      builder: (context, homeViewModel) {
        final selectedScreen = homeViewModel.selectedScreen;
        final destination = screenDestinationFor(selectedScreen);
        final isHomeSelected = selectedScreen == AppScreen.home;

        // ホーム画面は天気アプリ風の全画面表示にするためAppBarを出しません。
        return Scaffold(
          extendBody: isHomeSelected,
          appBar: isHomeSelected
              ? null
              : HomeScreenAppBar(destination: destination),
          body: HomeScreenBody(
            selectedScreen: selectedScreen,
            viewModels: viewModels,
          ),
          floatingActionButton: ExpandableScreenMenu(
            destinations: screenDestinationsFor(homeViewModel.availableScreens),
            selectedScreen: selectedScreen,
            isMenuOpen: homeViewModel.isMenuOpen,
            onMenuToggled: homeViewModel.toggleMenu,
            onScreenSelected: homeViewModel.selectScreen,
          ),
        );
      },
    );
  }
}
