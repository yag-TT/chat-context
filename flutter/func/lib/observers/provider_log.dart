import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ProviderLogEventType {
  added('生成'),
  updated('更新'),
  failed('失敗'),
  disposed('破棄'),
  unmounted('解放');

  const ProviderLogEventType(this.label);

  final String label;
}

@immutable
class ProviderLogEntry {
  const ProviderLogEntry({
    required this.type,
    required this.providerName,
    required this.occurredAt,
    this.previousValue,
    this.newValue,
    this.error,
  });

  final ProviderLogEventType type;
  final String providerName;
  final DateTime occurredAt;
  final String? previousValue;
  final String? newValue;
  final String? error;
}

class ProviderLogStore extends ChangeNotifier {
  ProviderLogStore({this.maximumEntries = 100});

  final int maximumEntries;
  final List<ProviderLogEntry> _entries = [];
  bool _isDisposed = false;

  List<ProviderLogEntry> get entries => List.unmodifiable(_entries);

  void add(ProviderLogEntry entry) {
    if (_isDisposed) {
      return;
    }
    _entries.insert(0, entry);
    if (_entries.length > maximumEntries) {
      _entries.removeRange(maximumEntries, _entries.length);
    }
    notifyListeners();
  }

  void clear() {
    if (_isDisposed || _entries.isEmpty) {
      return;
    }
    _entries.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

final providerLogStoreProvider = Provider<ProviderLogStore>((ref) {
  final store = ProviderLogStore();
  ref.onDispose(store.dispose);
  return store;
}, name: 'providerLogStore');

final class PlaygroundObserver extends ProviderObserver {
  const PlaygroundObserver(this.store);

  final ProviderLogStore store;

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    _add(context, ProviderLogEventType.added, newValue: _summarize(value));
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    _add(
      context,
      ProviderLogEventType.updated,
      previousValue: _summarize(previousValue),
      newValue: _summarize(newValue),
    );
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    _add(context, ProviderLogEventType.failed, error: _summarize(error));
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    _add(context, ProviderLogEventType.disposed);
  }

  @override
  void didUnmountProvider(ProviderObserverContext context) {
    _add(context, ProviderLogEventType.unmounted);
  }

  void _add(
    ProviderObserverContext context,
    ProviderLogEventType type, {
    String? previousValue,
    String? newValue,
    String? error,
  }) {
    store.add(
      ProviderLogEntry(
        type: type,
        providerName:
            context.provider.name ?? context.provider.runtimeType.toString(),
        occurredAt: DateTime.now(),
        previousValue: previousValue,
        newValue: newValue,
        error: error,
      ),
    );
  }

  String _summarize(Object? value) {
    final text = '$value'.replaceAll('\n', ' ');
    if (text.length <= 80) {
      return text;
    }
    return '${text.substring(0, 77)}...';
  }
}
