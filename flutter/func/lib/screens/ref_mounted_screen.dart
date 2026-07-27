import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/mounted_operation.dart';
import '../providers/async_control_providers.dart';
import '../widgets/demo_info_card.dart';

class RefMountedScreen extends ConsumerStatefulWidget {
  const RefMountedScreen({super.key});

  @override
  ConsumerState<RefMountedScreen> createState() => _RefMountedScreenState();
}

class _RefMountedScreenState extends ConsumerState<RefMountedScreen> {
  late final MountedOperationRecorder _recorder;
  bool _isSubscribed = true;

  @override
  void initState() {
    super.initState();
    _recorder = MountedOperationRecorder();
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scenario = MountedOperationScenario(
      recorder: _recorder,
      delay: ref.watch(mountedOperationDelayProvider),
    );
    final result = _isSubscribed
        ? ref.watch(mountedOperationProvider(scenario))
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Ref.mounted')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const DemoInfoCard(
              title: 'await後にProviderが有効か確認',
              description:
                  'Ref.mountedは進行中の処理自体を止めません。await完了後にProviderが'
                  '破棄済みなら、その後の更新処理を実行せず結果を無視します。',
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: result == null
                      ? const Column(
                          key: Key('mounted-unsubscribed'),
                          children: [
                            Icon(Icons.link_off, size: 48),
                            SizedBox(height: 12),
                            Text('Providerを購読していません'),
                          ],
                        )
                      : result.isLoading
                      ? const Column(
                          key: Key('mounted-loading'),
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 12),
                            Text('長い処理を実行中…'),
                          ],
                        )
                      : result.hasValue
                      ? Column(
                          key: const Key('mounted-completed'),
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '操作${result.requireValue.operationNumber}が正常完了しました',
                            ),
                          ],
                        )
                      : Text('${result.error}'),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              key: const Key('mounted-subscription-toggle'),
              title: const Text('Providerを購読する'),
              subtitle: const Text('処理中にOFFにするとautoDisposeされます'),
              value: _isSubscribed,
              onChanged: (value) => setState(() => _isSubscribed = value),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  key: const Key('mounted-restart'),
                  onPressed: _isSubscribed
                      ? () => ref.invalidate(mountedOperationProvider(scenario))
                      : null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('新しい処理を開始'),
                ),
                TextButton.icon(
                  onPressed: _recorder.clear,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('履歴を消去'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('操作履歴', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: _recorder,
              builder: (context, child) {
                return Column(
                  key: const Key('mounted-events'),
                  children: [
                    for (final event in _recorder.events)
                      ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          child: Text('${event.operationNumber}'),
                        ),
                        title: Text(event.type.label),
                        subtitle: Text(
                          event.occurredAt.toLocal().toIso8601String(),
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
