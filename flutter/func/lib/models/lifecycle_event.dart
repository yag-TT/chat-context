import 'package:flutter/foundation.dart';

enum LifecycleEventType {
  created('生成'),
  cancelled('購読解除'),
  resumed('購読再開'),
  disposed('破棄');

  const LifecycleEventType(this.label);

  final String label;
}

@immutable
class LifecycleEvent {
  const LifecycleEvent({required this.type, required this.occurredAt});

  final LifecycleEventType type;
  final DateTime occurredAt;
}

class LifecycleRecorder extends ChangeNotifier {
  final List<LifecycleEvent> _events = [];
  bool _isDisposed = false;

  List<LifecycleEvent> get events => List.unmodifiable(_events);

  void record(LifecycleEventType type) {
    if (_isDisposed) {
      return;
    }
    _events.insert(0, LifecycleEvent(type: type, occurredAt: DateTime.now()));
    notifyListeners();
  }

  void clear() {
    if (_isDisposed || _events.isEmpty) {
      return;
    }
    _events.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
