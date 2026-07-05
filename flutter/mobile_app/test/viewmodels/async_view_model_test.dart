import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/viewmodels/async_view_model.dart';

import '../helpers/change_notifier_counter.dart';

class _TestAsyncViewModel extends AsyncViewModel {
  int? _value;

  int? get value => _value;

  Future<void> succeed() {
    return runLoad(errorMessage: 'failed', load: () async {});
  }

  Future<void> fail() {
    return runLoad(
      errorMessage: 'failed',
      load: () async {
        throw Exception('load error');
      },
    );
  }

  Future<void> waitFor(Future<void> future) {
    return runLoad(errorMessage: 'failed', load: () => future);
  }

  Future<void> waitForValue(Future<int> future) {
    return runLoadValue(
      errorMessage: 'failed',
      load: () => future,
      onData: (value) {
        _value = value;
      },
    );
  }
}

void main() {
  test('runLoad clears loading state after success', () async {
    final viewModel = _TestAsyncViewModel();
    addTearDown(viewModel.dispose);

    await viewModel.succeed();

    expect(viewModel.isLoading, isFalse);
    expect(viewModel.errorMessage, isNull);
  });

  test('runLoad stores error message after exception', () async {
    final viewModel = _TestAsyncViewModel();
    addTearDown(viewModel.dispose);

    await viewModel.fail();

    expect(viewModel.isLoading, isFalse);
    expect(viewModel.errorMessage, 'failed');
  });

  test('runLoad notifies at loading start and finish', () async {
    final viewModel = _TestAsyncViewModel();
    addTearDown(viewModel.dispose);
    final notifications = ChangeNotifierCounter(viewModel);
    final load = Completer<void>();

    final runningLoad = viewModel.waitFor(load.future);

    expect(viewModel.isLoading, isTrue);
    expect(viewModel.errorMessage, isNull);
    expect(notifications.count, 1);

    load.complete();
    await runningLoad;

    expect(viewModel.isLoading, isFalse);
    expect(notifications.count, 2);
  });

  test('runLoad clears previous error when retry starts', () async {
    final viewModel = _TestAsyncViewModel();
    addTearDown(viewModel.dispose);

    await viewModel.fail();
    expect(viewModel.errorMessage, 'failed');

    final load = Completer<void>();
    final runningLoad = viewModel.waitFor(load.future);

    expect(viewModel.isLoading, isTrue);
    expect(viewModel.errorMessage, isNull);

    load.complete();
    await runningLoad;
  });

  test('runLoadValue does not apply data after dispose', () async {
    final viewModel = _TestAsyncViewModel();
    final notifications = ChangeNotifierCounter(viewModel);
    final load = Completer<int>();

    final runningLoad = viewModel.waitForValue(load.future);

    expect(viewModel.isLoading, isTrue);
    expect(notifications.count, 1);

    viewModel.dispose();
    load.complete(10);
    await runningLoad;

    expect(viewModel.value, isNull);
    expect(viewModel.isLoading, isFalse);
    expect(notifications.count, 1);
  });

  test('runLoadValue ignores stale data from older loads', () async {
    final viewModel = _TestAsyncViewModel();
    addTearDown(viewModel.dispose);
    final olderLoad = Completer<int>();
    final newerLoad = Completer<int>();

    final runningOlderLoad = viewModel.waitForValue(olderLoad.future);
    final runningNewerLoad = viewModel.waitForValue(newerLoad.future);

    newerLoad.complete(2);
    await runningNewerLoad;

    expect(viewModel.value, 2);
    expect(viewModel.isLoading, isFalse);

    olderLoad.complete(1);
    await runningOlderLoad;

    expect(viewModel.value, 2);
    expect(viewModel.isLoading, isFalse);
    expect(viewModel.errorMessage, isNull);
  });

  test('runLoadValue ignores stale errors from older loads', () async {
    final viewModel = _TestAsyncViewModel();
    addTearDown(viewModel.dispose);
    final olderLoad = Completer<int>();
    final newerLoad = Completer<int>();

    final runningOlderLoad = viewModel.waitForValue(olderLoad.future);
    final runningNewerLoad = viewModel.waitForValue(newerLoad.future);

    newerLoad.complete(3);
    await runningNewerLoad;

    olderLoad.completeError(Exception('old error'));
    await runningOlderLoad;

    expect(viewModel.value, 3);
    expect(viewModel.errorMessage, isNull);
    expect(viewModel.isLoading, isFalse);
  });
}
