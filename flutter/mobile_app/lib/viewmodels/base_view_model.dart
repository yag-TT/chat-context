import 'package:flutter/foundation.dart';

/// ViewModel共通の通知・破棄制御をまとめます。
///
/// dispose後に状態更新や通知が走らないようにし、非同期処理が遅れて完了しても
/// Widgetツリーへ不要な通知を送らないための土台です。
abstract class BaseViewModel extends ChangeNotifier {
  bool _isDisposed = false;

  bool get isDisposed {
    debugPrint('[DBG] [BaseViewModel] ::isDisposed() - 破棄済みか確認します');
    return _isDisposed;
  }

  bool updateState(VoidCallback update) {
    debugPrint('[DBG] [BaseViewModel] ::updateState() - 状態を更新して変更を通知します');
    if (_isDisposed) {
      return false;
    }

    update();
    notifyListenersIfActive();
    return true;
  }

  /// 値が変わった場合だけ更新して通知します。
  ///
  /// Stateクラスで `operator ==` を実装しておくと、同じ状態への更新では
  /// 再描画を発生させずに済みます。
  bool updateValue<T>(T currentValue, T nextValue, ValueSetter<T> update) {
    if (_isDisposed) {
      return false;
    }

    if (currentValue == nextValue) {
      return false;
    }

    update(nextValue);
    notifyListenersIfActive();
    return true;
  }

  void notifyListenersIfActive() {
    debugPrint(
      '[DBG] [BaseViewModel] ::notifyListenersIfActive() - 有効なViewModelへ変更通知します',
    );
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    debugPrint('[DBG] [BaseViewModel] ::dispose() - 保持しているリソースを破棄します');
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;
    super.dispose();
  }
}
