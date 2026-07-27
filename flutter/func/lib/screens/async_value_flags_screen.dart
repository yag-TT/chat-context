import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/async_control_providers.dart';
import '../widgets/demo_info_card.dart';

class AsyncValueFlagsScreen extends ConsumerWidget {
  const AsyncValueFlagsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(asyncFlagsProvider);
    final value = result.value;
    final stateKey = result.isRefreshing
        ? const Key('flags-refreshing')
        : result.isReloading
        ? const Key('flags-reloading')
        : result.isLoading
        ? const Key('flags-initial-loading')
        : const Key('flags-data');

    return Scaffold(
      appBar: AppBar(title: const Text('AsyncValue状態判定')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const DemoInfoCard(
              title: 'refresh と reload の違い',
              description:
                  '同じProviderを手動で再評価するとisRefreshing、watchしている依存値が'
                  '変化するとisReloadingになります。どちらも前回値を保持できます。',
            ),
            const SizedBox(height: 12),
            Card(
              key: stateKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _FlagChip(
                          label: 'isLoading',
                          isActive: result.isLoading,
                        ),
                        _FlagChip(
                          label: 'isRefreshing',
                          isActive: result.isRefreshing,
                        ),
                        _FlagChip(
                          label: 'isReloading',
                          isActive: result.isReloading,
                        ),
                        _FlagChip(label: 'hasValue', isActive: result.hasValue),
                        _FlagChip(label: 'hasError', isActive: result.hasError),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (value != null) ...[
                      Text('保持中の世代: ${value.generation}'),
                      Text('リクエスト番号: ${value.requestNumber}'),
                      Text(
                        '完了時刻: ${value.completedAt.toLocal().toIso8601String()}',
                      ),
                    ] else
                      const Text('初回データを読み込んでいます'),
                    if (result.isLoading) ...[
                      const SizedBox(height: 12),
                      const LinearProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  key: const Key('flags-refresh'),
                  onPressed: () => ref.invalidate(asyncFlagsProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('手動更新'),
                ),
                FilledButton.tonalIcon(
                  key: const Key('flags-reload'),
                  onPressed: () => ref
                      .read(asyncFlagsGenerationProvider.notifier)
                      .increment(),
                  icon: const Icon(Icons.change_circle_outlined),
                  label: const Text('依存値を変更'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FlagChip extends StatelessWidget {
  const _FlagChip({required this.label, required this.isActive});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        isActive ? Icons.check_circle : Icons.cancel_outlined,
        size: 18,
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline,
      ),
      label: Text('$label: $isActive'),
    );
  }
}
