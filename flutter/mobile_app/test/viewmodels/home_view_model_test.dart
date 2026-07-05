import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/app_screen.dart';
import 'package:mobile_app/viewmodels/home_view_model.dart';

import '../helpers/change_notifier_counter.dart';

void main() {
  test('selectScreen updates selected screen and closes menu', () {
    final viewModel = HomeViewModel();
    addTearDown(viewModel.dispose);

    viewModel.toggleMenu();
    expect(viewModel.isMenuOpen, isTrue);

    viewModel.selectScreen(AppScreen.search);

    expect(viewModel.selectedScreen, AppScreen.search);
    expect(viewModel.isMenuOpen, isFalse);
  });

  test('uses injected available screens', () {
    final availableScreens = [AppScreen.home, AppScreen.settings];
    final viewModel = HomeViewModel(availableScreens: availableScreens);
    addTearDown(viewModel.dispose);

    expect(viewModel.availableScreens, availableScreens);

    viewModel.selectScreen(AppScreen.notifications);
    expect(viewModel.selectedScreen, AppScreen.home);

    viewModel.selectScreen(AppScreen.settings);
    expect(viewModel.selectedScreen, AppScreen.settings);
  });

  test('selectScreen notifies only when selection or menu state changes', () {
    final viewModel = HomeViewModel();
    addTearDown(viewModel.dispose);
    final notifications = ChangeNotifierCounter(viewModel);

    viewModel.selectScreen(AppScreen.home);
    expect(notifications.count, 0);

    viewModel.toggleMenu();
    expect(notifications.count, 1);

    viewModel.selectScreen(AppScreen.home);
    expect(viewModel.isMenuOpen, isFalse);
    expect(notifications.count, 2);
  });

  test('does not update after dispose', () {
    final viewModel = HomeViewModel();

    viewModel.dispose();
    viewModel
      ..toggleMenu()
      ..selectScreen(AppScreen.search);

    expect(viewModel.isMenuOpen, isFalse);
    expect(viewModel.selectedScreen, AppScreen.home);
  });
}
