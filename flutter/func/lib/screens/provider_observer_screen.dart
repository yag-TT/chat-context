import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../observers/provider_log.dart';
import '../widgets/demo_info_card.dart';

class ProviderObserverScreen extends ConsumerStatefulWidget {
  const ProviderObserverScreen({super.key});

  @override
  ConsumerState<ProviderObserverScreen> createState() =>
      _ProviderObserverScreenState();
}

class _ProviderObserverScreenState
    extends ConsumerState<ProviderObserverScreen> {
  ProviderLogEventType? _selectedType;

  @override
  Widget build(BuildContext context) {
    final store = ref.read(providerLogStoreProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ProviderObserverログ'),
        actions: [
          IconButton(
            key: const Key('observer-clear'),
            tooltip: 'すべて消去',
            onPressed: store.clear,
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: store,
          builder: (context, child) {
            final entries = store.entries
                .where(
                  (entry) =>
                      _selectedType == null || entry.type == _selectedType,
                )
                .toList(growable: false);

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const DemoInfoCard(
                  title: 'ProviderObserver',
                  description:
                      '全画面のProvider生成・更新・失敗・破棄をルートから監視します。'
                      '別画面で操作した履歴もこのセッション中は残ります。',
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      key: const Key('observer-filter-all'),
                      label: const Text('すべて'),
                      selected: _selectedType == null,
                      onSelected: (_) => setState(() => _selectedType = null),
                    ),
                    for (final type in ProviderLogEventType.values)
                      ChoiceChip(
                        key: Key('observer-filter-${type.name}'),
                        label: Text(type.label),
                        selected: _selectedType == type,
                        onSelected: (_) {
                          setState(() => _selectedType = type);
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${entries.length}件表示 / ${store.entries.length}件記録',
                  key: const Key('observer-count'),
                ),
                const SizedBox(height: 8),
                if (entries.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('該当するログはありません')),
                    ),
                  )
                else
                  for (final entry in entries) _ProviderLogCard(entry: entry),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProviderLogCard extends StatelessWidget {
  const _ProviderLogCard({required this.entry});

  final ProviderLogEntry entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Chip(label: Text(entry.type.label)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.providerName,
                    key: Key('observer-provider-${entry.providerName}'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Text(
                  _formatObserverTime(entry.occurredAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (entry.previousValue != null)
              Text('変更前: ${entry.previousValue}'),
            if (entry.newValue != null) Text('変更後: ${entry.newValue}'),
            if (entry.error != null)
              Text(
                'エラー: ${entry.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      ),
    );
  }
}

String _formatObserverTime(DateTime value) {
  final local = value.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}:'
      '${local.second.toString().padLeft(2, '0')}';
}
