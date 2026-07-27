import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/async_flags_result.dart';
import '../models/mounted_operation.dart';
import '../models/retry_scenario.dart';

final retryOperationDelayProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 300),
  name: 'retryOperationDelay',
);

final retryBaseDelayProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 500),
  name: 'retryBaseDelay',
);

Duration? demoRetryPolicy(int retryCount, Object error) {
  if (retryCount >= 2 || error is! RetryDemoException) {
    return null;
  }
  return Duration(
    microseconds: error.baseRetryDelay.inMicroseconds * (retryCount + 1),
  );
}

final automaticRetryProvider = FutureProvider.autoDispose
    .family<String, RetryScenario>(
      (ref, scenario) async {
        final attempt = scenario.recorder.startAttempt();
        await Future<void>.delayed(scenario.operationDelay);
        if (attempt <= scenario.failuresBeforeSuccess) {
          scenario.recorder.markFailed(attempt);
          throw RetryDemoException(
            attempt: attempt,
            baseRetryDelay: scenario.baseRetryDelay,
          );
        }
        scenario.recorder.markSucceeded(attempt);
        return '試行$attemptで取得に成功しました';
      },
      name: 'automaticRetry',
      retry: demoRetryPolicy,
    );

class AsyncFlagsGenerationNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

class AsyncFlagsRequestCounter {
  int _requestNumber = 0;

  int next() => ++_requestNumber;
}

final asyncFlagsGenerationProvider =
    NotifierProvider<AsyncFlagsGenerationNotifier, int>(
      AsyncFlagsGenerationNotifier.new,
      name: 'asyncFlagsGeneration',
    );

final asyncFlagsDelayProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 700),
  name: 'asyncFlagsDelay',
);

final asyncFlagsRequestCounterProvider = Provider<AsyncFlagsRequestCounter>(
  (ref) => AsyncFlagsRequestCounter(),
  name: 'asyncFlagsRequestCounter',
);

final asyncFlagsProvider = FutureProvider<AsyncFlagsResult>(
  (ref) async {
    final generation = ref.watch(asyncFlagsGenerationProvider);
    final delay = ref.watch(asyncFlagsDelayProvider);
    final requestNumber = ref.read(asyncFlagsRequestCounterProvider).next();
    await Future<void>.delayed(delay);
    return AsyncFlagsResult(
      generation: generation,
      requestNumber: requestNumber,
      completedAt: DateTime.now(),
    );
  },
  name: 'asyncFlags',
  retry: (retryCount, error) => null,
);

final mountedOperationDelayProvider = Provider<Duration>(
  (ref) => const Duration(seconds: 2),
  name: 'mountedOperationDelay',
);

final mountedOperationProvider = FutureProvider.autoDispose
    .family<MountedOperationResult, MountedOperationScenario>(
      (ref, scenario) async {
        final operationNumber = scenario.recorder.start();
        await Future<void>.delayed(scenario.delay);
        if (!ref.mounted) {
          scenario.recorder.ignoreAfterDispose(operationNumber);
          return MountedOperationResult(
            operationNumber: operationNumber,
            completedAt: DateTime.now(),
          );
        }
        scenario.recorder.complete(operationNumber);
        return MountedOperationResult(
          operationNumber: operationNumber,
          completedAt: DateTime.now(),
        );
      },
      name: 'mountedOperation',
      retry: (retryCount, error) => null,
    );
