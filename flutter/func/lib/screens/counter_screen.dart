import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/counter_providers.dart';
import '../widgets/demo_info_card.dart';

class CounterScreen extends ConsumerWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final label = ref.watch(counterLabelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('状態と派生値')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const DemoInfoCard(
              title: 'NotifierProvider',
              description:
                  '表示はref.watchで状態を監視し、ボタンはref.readでNotifierのメソッドを呼びます。'
                  '派生Providerはカウンターから偶数・奇数の文言を計算します。',
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text('ref.watch が監視している値'),
                    const SizedBox(height: 8),
                    Text(
                      '$count',
                      key: const Key('counter-value'),
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    Text(label, key: const Key('counter-label')),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.icon(
                          key: const Key('counter-decrement'),
                          onPressed: () =>
                              ref.read(counterProvider.notifier).decrement(),
                          icon: const Icon(Icons.remove),
                          label: const Text('減らす'),
                        ),
                        FilledButton.icon(
                          key: const Key('counter-increment'),
                          onPressed: () =>
                              ref.read(counterProvider.notifier).increment(),
                          icon: const Icon(Icons.add),
                          label: const Text('増やす'),
                        ),
                        OutlinedButton.icon(
                          key: const Key('counter-reset'),
                          onPressed: () =>
                              ref.read(counterProvider.notifier).reset(),
                          icon: const Icon(Icons.refresh),
                          label: const Text('リセット'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const _SelectExample(),
          ],
        ),
      ),
    );
  }
}

class _SelectExample extends ConsumerWidget {
  const _SelectExample();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNonNegative = ref.watch(
      counterProvider.select((count) => count >= 0),
    );

    return DemoInfoCard(
      title: 'select が監視している条件',
      description: isNonNegative
          ? '現在は0以上です。この領域は「0以上かどうか」が変化したときだけ更新対象になります。'
          : '現在は負の値です。この領域は「0以上かどうか」が変化したときだけ更新対象になります。',
    );
  }
}
