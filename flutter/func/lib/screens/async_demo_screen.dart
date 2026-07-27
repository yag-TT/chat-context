import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/async_demo_result.dart';
import '../providers/async_demo_providers.dart';
import '../widgets/demo_info_card.dart';

class AsyncDemoScreen extends ConsumerWidget {
  const AsyncDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<AsyncDemoResult>>(asyncDemoProvider, (
      previous,
      next,
    ) {
      if (previous?.isLoading != true) {
        return;
      }

      final message = switch (next) {
        AsyncData(:final value) => '成功: ${value.message}',
        AsyncError(:final error) => '失敗: $error',
        _ => null,
      };

      if (message != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      }
    });

    final asyncResult = ref.watch(asyncDemoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('非同期状態')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const DemoInfoCard(
              title: 'AsyncNotifier + AsyncValue',
              description:
                  'ローカル疑似APIを使い、loading・data・errorを確実に再現します。'
                  '状態遷移はref.listenでも監視し、完了時にSnackBarを表示します。',
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: switch (asyncResult) {
                    AsyncData(:final value) => _AsyncDataView(
                      key: const Key('async-data'),
                      value: value,
                    ),
                    AsyncError(:final error) => _AsyncErrorView(
                      key: const Key('async-error'),
                      error: error,
                    ),
                    _ => const Column(
                      key: Key('async-loading'),
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('読み込み中…'),
                      ],
                    ),
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  key: const Key('async-load-success'),
                  onPressed: () =>
                      ref.read(asyncDemoProvider.notifier).loadSuccess(),
                  icon: const Icon(Icons.download),
                  label: const Text('成功を読み込む'),
                ),
                FilledButton.tonalIcon(
                  key: const Key('async-load-failure'),
                  onPressed: () =>
                      ref.read(asyncDemoProvider.notifier).loadFailure(),
                  icon: const Icon(Icons.error_outline),
                  label: const Text('失敗させる'),
                ),
                OutlinedButton.icon(
                  key: const Key('async-retry'),
                  onPressed: () => ref.read(asyncDemoProvider.notifier).retry(),
                  icon: const Icon(Icons.replay),
                  label: const Text('再試行'),
                ),
                OutlinedButton.icon(
                  key: const Key('async-invalidate'),
                  onPressed: () => ref.invalidate(asyncDemoProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('invalidate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AsyncDataView extends StatelessWidget {
  const _AsyncDataView({super.key, required this.value});

  final AsyncDemoResult value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
        const SizedBox(height: 12),
        Text(value.message, textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text('リクエスト番号: ${value.requestNumber}'),
        Text(
          '完了時刻: ${value.completedAt.toLocal().toIso8601String()}',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _AsyncErrorView extends StatelessWidget {
  const _AsyncErrorView({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.error,
          size: 48,
        ),
        const SizedBox(height: 12),
        const Text('エラーが発生しました'),
        const SizedBox(height: 4),
        Text('$error', textAlign: TextAlign.center),
      ],
    );
  }
}
