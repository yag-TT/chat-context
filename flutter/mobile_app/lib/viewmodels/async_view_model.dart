import 'package:flutter/foundation.dart';

import 'base_view_model.dart';

/// Repositoryなどから非同期にデータを取得するViewModelの共通基底です。
///
/// 読み込み中・エラー状態を共通化し、複数の読み込みが重なった場合は
/// 最後に開始した読み込み結果だけを画面状態へ反映します。
abstract class AsyncViewModel extends BaseViewModel {
  String? _errorMessage;
  bool _isLoading = false;
  int _loadGeneration = 0;

  String? get errorMessage {
    debugPrint('[DBG] [AsyncViewModel] ::errorMessage() - エラーメッセージを参照します');
    return _errorMessage;
  }

  bool get isLoading {
    debugPrint('[DBG] [AsyncViewModel] ::isLoading() - 読み込み中か確認します');
    return _isLoading;
  }

  Future<void> runLoad({
    required String errorMessage,
    required Future<void> Function() load,
  }) async {
    debugPrint('[DBG] [AsyncViewModel] ::runLoad() - 非同期読み込み処理を実行します');
    await runLoadValue<void>(
      errorMessage: errorMessage,
      load: load,
      onData: (_) {},
    );
  }

  Future<void> runLoadValue<T>({
    required String errorMessage,
    required Future<T> Function() load,
    required ValueSetter<T> onData,
  }) async {
    debugPrint('[DBG] [AsyncViewModel] ::runLoadValue() - 非同期読み込み結果を状態へ反映します');
    if (isDisposed) {
      return;
    }

    final loadGeneration = _startLoad();

    try {
      final data = await load();
      if (_isCurrentLoad(loadGeneration)) {
        onData(data);
      }
    } on Exception {
      _setErrorIfCurrent(loadGeneration, errorMessage);
    } finally {
      _finishLoad(loadGeneration);
    }
  }

  int _startLoad() {
    debugPrint('[DBG] [AsyncViewModel] ::_startLoad() - 読み込み開始状態へ更新します');
    _loadGeneration += 1;
    _isLoading = true;
    _errorMessage = null;
    notifyListenersIfActive();
    return _loadGeneration;
  }

  bool _isCurrentLoad(int loadGeneration) {
    debugPrint('[DBG] [AsyncViewModel] ::_isCurrentLoad() - 最新の読み込み処理か確認します');
    return !isDisposed && loadGeneration == _loadGeneration;
  }

  void _setErrorIfCurrent(int loadGeneration, String errorMessage) {
    debugPrint(
      '[DBG] [AsyncViewModel] ::_setErrorIfCurrent() - 最新の読み込みエラーを状態へ反映します',
    );
    if (_isCurrentLoad(loadGeneration)) {
      _errorMessage = errorMessage;
    }
  }

  void _finishLoad(int loadGeneration) {
    debugPrint('[DBG] [AsyncViewModel] ::_finishLoad() - 読み込み終了状態へ更新します');
    if (isDisposed) {
      if (loadGeneration == _loadGeneration) {
        _isLoading = false;
      }
      return;
    }

    if (loadGeneration != _loadGeneration) {
      return;
    }

    _isLoading = false;
    notifyListenersIfActive();
  }
}
