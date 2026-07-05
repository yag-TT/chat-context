import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/viewmodels/base_view_model.dart';

import '../helpers/change_notifier_counter.dart';

class _TestViewModel extends BaseViewModel {
  int _value = 0;
  int _otherValue = 0;

  int get value => _value;

  int get otherValue => _otherValue;

  void setValue(int value) {
    updateValue(_value, value, (nextValue) {
      _value = nextValue;
    });
  }

  void setValues(int value, int otherValue) {
    updateState(() {
      _value = value;
      _otherValue = otherValue;
    });
  }

  void update() {
    notifyListenersIfActive();
  }
}

void main() {
  test('notifyListenersIfActive stops notifying after dispose', () {
    final viewModel = _TestViewModel();
    final notifications = ChangeNotifierCounter(viewModel);

    viewModel.update();
    expect(notifications.count, 1);
    expect(viewModel.isDisposed, isFalse);

    viewModel.dispose();
    viewModel.update();

    expect(notifications.count, 1);
    expect(viewModel.isDisposed, isTrue);
  });

  test('updateValue notifies only when value changes', () {
    final viewModel = _TestViewModel();
    addTearDown(viewModel.dispose);
    final notifications = ChangeNotifierCounter(viewModel);

    viewModel.setValue(0);
    expect(notifications.count, 0);

    viewModel.setValue(1);
    expect(viewModel.value, 1);
    expect(notifications.count, 1);
  });

  test('updateState updates state and notifies once', () {
    final viewModel = _TestViewModel();
    addTearDown(viewModel.dispose);
    final notifications = ChangeNotifierCounter(viewModel);

    viewModel.setValues(1, 2);

    expect(viewModel.value, 1);
    expect(viewModel.otherValue, 2);
    expect(notifications.count, 1);
  });

  test('updateState does not update after dispose', () {
    final viewModel = _TestViewModel();

    viewModel.dispose();
    viewModel.setValues(1, 2);

    expect(viewModel.value, 0);
    expect(viewModel.otherValue, 0);
  });

  test('updateValue does not update after dispose', () {
    final viewModel = _TestViewModel();

    viewModel.dispose();
    viewModel.setValue(1);

    expect(viewModel.value, 0);
  });

  test('dispose can be called more than once', () {
    final viewModel = _TestViewModel();

    viewModel
      ..dispose()
      ..dispose();

    expect(viewModel.isDisposed, isTrue);
  });
}
