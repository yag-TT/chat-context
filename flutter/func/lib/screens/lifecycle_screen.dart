import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/lifecycle_event.dart';
import '../providers/lifecycle_providers.dart';
import '../widgets/demo_info_card.dart';

class LifecycleScreen extends ConsumerStatefulWidget {
  const LifecycleScreen({super.key});

  @override
  ConsumerState<LifecycleScreen> createState() => _LifecycleScreenState();
}

class _LifecycleScreenState extends ConsumerState<LifecycleScreen> {
  late final LifecycleRecorder _autoDisposeRecorder;
  late final LifecycleRecorder _keepAliveRecorder;
  late final LifecycleProbeConfiguration _autoDisposeConfiguration;
  late final LifecycleProbeConfiguration _keepAliveConfiguration;
  bool _watchAutoDispose = true;
  bool _watchKeepAlive = true;

  @override
  void initState() {
    super.initState();
    _autoDisposeRecorder = LifecycleRecorder();
    _keepAliveRecorder = LifecycleRecorder();
    _autoDisposeConfiguration = LifecycleProbeConfiguration(
      recorder: _autoDisposeRecorder,
      keepAlive: false,
    );
    _keepAliveConfiguration = LifecycleProbeConfiguration(
      recorder: _keepAliveRecorder,
      keepAlive: true,
    );
  }

  @override
  void dispose() {
    _autoDisposeRecorder.dispose();
    _keepAliveRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Providerライフサイクル')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const DemoInfoCard(
              title: 'autoDispose と keepAlive',
              description:
                  '購読を外したときのonCancel・onDisposeと、keepAliveされたProviderを'
                  '再購読したときのonResumeを比較します。',
            ),
            const SizedBox(height: 12),
            _LifecycleCard(
              title: '通常のautoDispose',
              description: '購読をOFFにすると、onCancelの後にProviderが破棄されます。',
              configuration: _autoDisposeConfiguration,
              recorder: _autoDisposeRecorder,
              isSubscribed: _watchAutoDispose,
              toggleKey: const Key('lifecycle-auto-toggle'),
              logKey: const Key('lifecycle-auto-log'),
              onSubscriptionChanged: (value) {
                setState(() => _watchAutoDispose = value);
              },
            ),
            const SizedBox(height: 12),
            _LifecycleCard(
              title: 'ref.keepAlive()',
              description: '購読をOFFにしても保持され、ONに戻すとonResumeが呼ばれます。',
              configuration: _keepAliveConfiguration,
              recorder: _keepAliveRecorder,
              isSubscribed: _watchKeepAlive,
              toggleKey: const Key('lifecycle-keep-toggle'),
              logKey: const Key('lifecycle-keep-log'),
              onSubscriptionChanged: (value) {
                setState(() => _watchKeepAlive = value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LifecycleCard extends ConsumerWidget {
  const _LifecycleCard({
    required this.title,
    required this.description,
    required this.configuration,
    required this.recorder,
    required this.isSubscribed,
    required this.toggleKey,
    required this.logKey,
    required this.onSubscriptionChanged,
  });

  final String title;
  final String description;
  final LifecycleProbeConfiguration configuration;
  final LifecycleRecorder recorder;
  final bool isSubscribed;
  final Key toggleKey;
  final Key logKey;
  final ValueChanged<bool> onSubscriptionChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = isSubscribed
        ? ref.watch(lifecycleProbeProvider(configuration))
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(description),
            SwitchListTile(
              key: toggleKey,
              contentPadding: EdgeInsets.zero,
              title: const Text('Providerを購読する'),
              value: isSubscribed,
              onChanged: onSubscriptionChanged,
            ),
            Text(value == null ? '現在値: 未購読' : 'Providerインスタンス: $value'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    ref.invalidate(lifecycleProbeProvider(configuration));
                  },
                  icon: const Icon(Icons.delete_sweep_outlined),
                  label: const Text('invalidate'),
                ),
                TextButton.icon(
                  onPressed: recorder.clear,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('ログ消去'),
                ),
              ],
            ),
            const Divider(height: 24),
            Text('イベント履歴', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: recorder,
              builder: (context, child) {
                final events = recorder.events;
                if (events.isEmpty) {
                  return const Text('イベントはまだありません');
                }
                return Column(
                  key: logKey,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final event in events)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '${_formatTime(event.occurredAt)}  ${event.type.label}',
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String _formatTime(DateTime value) {
  final local = value.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}:'
      '${local.second.toString().padLeft(2, '0')}.'
      '${local.millisecond.toString().padLeft(3, '0')}';
}
