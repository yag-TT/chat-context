import '../models/app_screen.dart';
import 'base_view_model.dart';
import 'package:flutter/foundation.dart';

/// 画面選択とフローティングメニューの開閉状態を管理します。
class HomeViewModel extends BaseViewModel {
  HomeViewModel({List<AppScreen> availableScreens = defaultAppScreens})
    : assert(availableScreens.isNotEmpty),
      assert(availableScreens.contains(AppScreen.home)),
      _availableScreens = List.unmodifiable(availableScreens);

  final List<AppScreen> _availableScreens;
  AppScreen _selectedScreen = AppScreen.home;
  bool _isMenuOpen = false;

  List<AppScreen> get availableScreens {
    debugPrint('[DBG] [HomeViewModel] ::availableScreens() - 表示可能な画面一覧を参照します');
    return _availableScreens;
  }

  bool get isMenuOpen {
    debugPrint('[DBG] [HomeViewModel] ::isMenuOpen() - メニューの開閉状態を参照します');
    return _isMenuOpen;
  }

  AppScreen get selectedScreen {
    debugPrint('[DBG] [HomeViewModel] ::selectedScreen() - 選択中の画面を参照します');
    return _selectedScreen;
  }

  void toggleMenu() {
    debugPrint('[DBG] [HomeViewModel] ::toggleMenu() - 画面メニューの開閉を切り替えます');
    updateState(() {
      debugPrint('[DBG] [HomeViewModel] ::updateState() - 状態を更新して変更を通知します');
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void selectScreen(AppScreen screen) {
    debugPrint('[DBG] [HomeViewModel] ::selectScreen() - 選択された画面へ切り替えます');
    if (!_availableScreens.contains(screen)) {
      return;
    }

    // 同じ画面を選び直してメニューも閉じている場合は、通知を出しません。
    if (_selectedScreen == screen && !_isMenuOpen) {
      return;
    }

    updateState(() {
      debugPrint('[DBG] [HomeViewModel] ::updateState() - 状態を更新して変更を通知します');
      _selectedScreen = screen;
      _isMenuOpen = false;
    });
  }
}
