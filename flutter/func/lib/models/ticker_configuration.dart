import 'package:flutter/foundation.dart';

@immutable
class TickerConfiguration {
  const TickerConfiguration({required this.interval, this.errorAfter});

  final Duration interval;
  final int? errorAfter;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TickerConfiguration &&
            interval == other.interval &&
            errorAfter == other.errorAfter;
  }

  @override
  int get hashCode => Object.hash(interval, errorAfter);
}
