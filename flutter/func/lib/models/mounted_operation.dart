import 'package:flutter/foundation.dart';

enum MountedOperationEventType {
  started('開始'),
  completed('正常完了'),
  ignoredAfterDispose('破棄後に結果を無視');

  const MountedOperationEventType(this.label);

  final String label;
}

@immutable
class MountedOperationEvent {
  const MountedOperationEvent({
    required this.operationNumber,
    required this.type,
    required this.occurredAt,
  });

  final int operationNumber;
  final MountedOperationEventType type;
  final DateTime occurredAt;
}

class MountedOperationRecorder extends ChangeNotifier {
  final List<MountedOperationEvent> _events = [];
  bool _isDisposed = false;
  int _nextOperationNumber = 1;

  List<MountedOperationEvent> get events => List.unmodifiable(_events);

  int start() {
    final operationNumber = _nextOperationNumber++;
    _record(operationNumber, MountedOperationEventType.started);
    return operationNumber;
  }

  void complete(int operationNumber) {
    _record(operationNumber, MountedOperationEventType.completed);
  }

  void ignoreAfterDispose(int operationNumber) {
    _record(operationNumber, MountedOperationEventType.ignoredAfterDispose);
  }

  void clear() {
    if (_isDisposed || _events.isEmpty) {
      return;
    }
    _events.clear();
    notifyListeners();
  }

  void _record(int operationNumber, MountedOperationEventType type) {
    if (_isDisposed) {
      return;
    }
    _events.insert(
      0,
      MountedOperationEvent(
        operationNumber: operationNumber,
        type: type,
        occurredAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

@immutable
class MountedOperationScenario {
  const MountedOperationScenario({required this.recorder, required this.delay});

  final MountedOperationRecorder recorder;
  final Duration delay;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MountedOperationScenario &&
            identical(recorder, other.recorder) &&
            delay == other.delay;
  }

  @override
  int get hashCode => Object.hash(identityHashCode(recorder), delay);
}

@immutable
class MountedOperationResult {
  const MountedOperationResult({
    required this.operationNumber,
    required this.completedAt,
  });

  final int operationNumber;
  final DateTime completedAt;
}
