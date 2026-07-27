import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ticker_configuration.dart';
import '../providers/stream_providers.dart';
import '../widgets/demo_info_card.dart';

class StreamDemoScreen extends ConsumerStatefulWidget {
  const StreamDemoScreen({super.key});

  @override
  ConsumerState<StreamDemoScreen> createState() => _StreamDemoScreenState();
}

class _StreamDemoScreenState extends ConsumerState<StreamDemoScreen> {
  bool _isSubscribed = true;
  bool _shouldFail = false;

  @override
  Widget build(BuildContext context) {
    final configuration = TickerConfiguration(
      interval: ref.watch(tickerIntervalProvider),
      errorAfter: _shouldFail ? 3 : null,
    );
    final ticker = _isSubscribed
        ? ref.watch(tickerProvider(configuration))
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Streamとリアルタイム更新')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const DemoInfoCard(
              title: 'StreamProvider.autoDispose.family',
              description:
                  '購読中はTickerが定期的に値を配信します。購読を止めるとautoDisposeが働き、'
                  '再開時には新しいStreamが0から生成されます。',
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ticker == null
                      ? const Column(
                          key: Key('stream-unsubscribed'),
                          children: [
                            Icon(Icons.pause_circle_outline, size: 48),
                            SizedBox(height: 12),
                            Text('購読を停止しています'),
                          ],
                        )
                      : switch (ticker) {
                          AsyncData(:final value) => Column(
                            key: const Key('stream-data'),
                            children: [
                              const Icon(Icons.sensors, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                '$value',
                                key: const Key('stream-value'),
                                style: Theme.of(
                                  context,
                                ).textTheme.displayMedium,
                              ),
                              const Text('Streamから受信した現在値'),
                            ],
                          ),
                          AsyncError(:final error) => Column(
                            key: const Key('stream-error'),
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 48,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              const SizedBox(height: 12),
                              const Text('Streamがエラーになりました'),
                              Text('$error', textAlign: TextAlign.center),
                            ],
                          ),
                          _ => const Column(
                            key: Key('stream-loading'),
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 12),
                              Text('最初のイベントを待っています…'),
                            ],
                          ),
                        },
                ),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              key: const Key('stream-subscription-toggle'),
              title: const Text('Streamを購読する'),
              subtitle: const Text('OFFにすると最後のリスナーが外れます'),
              value: _isSubscribed,
              onChanged: (value) => setState(() => _isSubscribed = value),
            ),
            SwitchListTile(
              key: const Key('stream-error-toggle'),
              title: const Text('3イベント後にエラー'),
              subtitle: const Text('自動再試行を無効化し、error状態を確認します'),
              value: _shouldFail,
              onChanged: (value) => setState(() => _shouldFail = value),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              key: const Key('stream-restart'),
              onPressed: () => ref.invalidate(tickerProvider(configuration)),
              icon: const Icon(Icons.restart_alt),
              label: const Text('Providerを再起動'),
            ),
          ],
        ),
      ),
    );
  }
}
