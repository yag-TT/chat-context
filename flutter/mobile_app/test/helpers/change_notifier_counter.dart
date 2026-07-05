import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class ChangeNotifierCounter {
  ChangeNotifierCounter(this._notifier) {
    _notifier.addListener(_increment);
    addTearDown(dispose);
  }

  final ChangeNotifier _notifier;
  var count = 0;
  var _isDisposed = false;

  void reset() {
    count = 0;
  }

  void dispose() {
    if (_isDisposed) {
      return;
    }

    _notifier.removeListener(_increment);
    _isDisposed = true;
  }

  void _increment() {
    count += 1;
  }
}
