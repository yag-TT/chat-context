import 'package:flutter/foundation.dart';

@immutable
class AsyncFlagsResult {
  const AsyncFlagsResult({
    required this.generation,
    required this.requestNumber,
    required this.completedAt,
  });

  final int generation;
  final int requestNumber;
  final DateTime completedAt;
}
