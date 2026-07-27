import '../models/async_demo_result.dart';

abstract interface class DemoRepository {
  Future<AsyncDemoResult> fetch({required bool shouldFail});
}

class LocalDemoRepository implements DemoRepository {
  int _requestCount = 0;

  @override
  Future<AsyncDemoResult> fetch({required bool shouldFail}) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    _requestCount++;

    if (shouldFail) {
      throw StateError('疑似APIが意図的なエラーを返しました');
    }

    return AsyncDemoResult(
      message: 'ローカル疑似APIからデータを取得しました',
      requestNumber: _requestCount,
      completedAt: DateTime.now(),
    );
  }
}
