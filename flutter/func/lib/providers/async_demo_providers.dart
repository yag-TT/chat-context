import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/async_demo_result.dart';
import '../repositories/demo_repository.dart';

final demoRepositoryProvider = Provider<DemoRepository>(
  (ref) => LocalDemoRepository(),
  name: 'demoRepository',
);

class AsyncDemoNotifier extends AsyncNotifier<AsyncDemoResult> {
  @override
  Future<AsyncDemoResult> build() {
    return ref.watch(demoRepositoryProvider).fetch(shouldFail: false);
  }

  Future<void> loadSuccess() => _load(shouldFail: false);

  Future<void> loadFailure() => _load(shouldFail: true);

  Future<void> retry() => loadSuccess();

  Future<void> _load({required bool shouldFail}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(demoRepositoryProvider).fetch(shouldFail: shouldFail),
    );
  }
}

final asyncDemoProvider =
    AsyncNotifierProvider<AsyncDemoNotifier, AsyncDemoResult>(
      AsyncDemoNotifier.new,
      name: 'asyncDemo',
    );
