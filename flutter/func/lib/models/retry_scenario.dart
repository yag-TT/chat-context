import 'package:flutter/foundation.dart';

enum RetryAttemptStatus {
  running('実行中'),
  failed('失敗'),
  succeeded('成功');

  const RetryAttemptStatus(this.label);

  final String label;
}

@immutable
class RetryAttempt {
  const RetryAttempt({
    required this.number,
    required this.status,
    required this.occurredAt,
  });

  final int number;
  final RetryAttemptStatus status;
  final DateTime occurredAt;

  RetryAttempt copyWith({required RetryAttemptStatus status}) {
    return RetryAttempt(
      number: number,
      status: status,
      occurredAt: DateTime.now(),
    );
  }
}

class RetryAttemptRecorder extends ChangeNotifier {
  final List<RetryAttempt> _attempts = [];
  bool _isDisposed = false;

  List<RetryAttempt> get attempts => List.unmodifiable(_attempts);

  int startAttempt() {
    final number = _attempts.length + 1;
    _attempts.add(
      RetryAttempt(
        number: number,
        status: RetryAttemptStatus.running,
        occurredAt: DateTime.now(),
      ),
    );
    _notify();
    return number;
  }

  void markFailed(int number) {
    _update(number, RetryAttemptStatus.failed);
  }

  void markSucceeded(int number) {
    _update(number, RetryAttemptStatus.succeeded);
  }

  void clear() {
    if (_isDisposed || _attempts.isEmpty) {
      return;
    }
    _attempts.clear();
    notifyListeners();
  }

  void _update(int number, RetryAttemptStatus status) {
    if (_isDisposed) {
      return;
    }
    final index = _attempts.indexWhere((attempt) => attempt.number == number);
    if (index == -1) {
      return;
    }
    _attempts[index] = _attempts[index].copyWith(status: status);
    notifyListeners();
  }

  void _notify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

@immutable
class RetryScenario {
  const RetryScenario({
    required this.recorder,
    required this.failuresBeforeSuccess,
    required this.operationDelay,
    required this.baseRetryDelay,
  });

  final RetryAttemptRecorder recorder;
  final int failuresBeforeSuccess;
  final Duration operationDelay;
  final Duration baseRetryDelay;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RetryScenario &&
            identical(recorder, other.recorder) &&
            failuresBeforeSuccess == other.failuresBeforeSuccess &&
            operationDelay == other.operationDelay &&
            baseRetryDelay == other.baseRetryDelay;
  }

  @override
  int get hashCode => Object.hash(
    identityHashCode(recorder),
    failuresBeforeSuccess,
    operationDelay,
    baseRetryDelay,
  );
}

class RetryDemoException implements Exception {
  const RetryDemoException({
    required this.attempt,
    required this.baseRetryDelay,
  });

  final int attempt;
  final Duration baseRetryDelay;

  @override
  String toString() => '試行$attemptは意図的に失敗しました';
}
