class AsyncDemoResult {
  const AsyncDemoResult({
    required this.message,
    required this.requestNumber,
    required this.completedAt,
  });

  final String message;
  final int requestNumber;
  final DateTime completedAt;
}
