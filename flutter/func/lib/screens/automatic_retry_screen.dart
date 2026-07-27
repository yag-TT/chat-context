import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/retry_scenario.dart';
import '../providers/async_control_providers.dart';
import '../widgets/demo_info_card.dart';

class AutomaticRetryScreen extends ConsumerStatefulWidget {
  const AutomaticRetryScreen({super.key});

  @override
  ConsumerState<AutomaticRetryScreen> createState() =>
      _AutomaticRetryScreenState();
}

class _AutomaticRetryScreenState extends ConsumerState<AutomaticRetryScreen> {
  late final RetryAttemptRecorder _recorder;
  bool _alwaysFail = false;

  @override
  void initState() {
    super.initState();
    _recorder = RetryAttemptRecorder();
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseRetryDelay = ref.watch(retryBaseDelayProvider);
    final scenario = RetryScenario(
      recorder: _recorder,
      failuresBeforeSuccess: _alwaysFail ? 99 : 2,
      operationDelay: ref.watch(retryOperationDelayProvider),
      baseRetryDelay: baseRetryDelay,
    );
    final result = ref.watch(automaticRetryProvider(scenario));
    final nextDelay = _nextDelay(result, baseRetryDelay);

    return Scaffold(
      appBar: AppBar(title: const Text('自動リトライ')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const DemoInfoCard(
              title: 'Provider固有のretryポリシー',
              description:
                  '失敗時にProviderを自動再評価します。標準シナリオは2回失敗し、'
                  '500ミリ秒・1秒待って3回目に成功します。',
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (result.retrying)
                      Column(
                        key: const Key('retry-retrying'),
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 12),
                          const Text('エラーから自動リトライを待機中'),
                          if (nextDelay != null)
                            Text('次の試行まで約${nextDelay.inMilliseconds}ms'),
                        ],
                      )
                    else if (result.isLoading)
                      const Column(
                        key: Key('retry-loading'),
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('処理を実行中…'),
                        ],
                      )
                    else if (result.hasValue)
                      Column(
                        key: const Key('retry-success'),
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          Text(result.requireValue),
                        ],
                      )
                    else if (result.hasError)
                      Column(
                        key: const Key('retry-error'),
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Theme.of(context).colorScheme.error,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          const Text('規定回数内に成功しませんでした'),
                          Text('${result.error}', textAlign: TextAlign.center),
                        ],
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              key: const Key('retry-always-fail-toggle'),
              title: const Text('常に失敗する'),
              subtitle: const Text('ONでは3回試行後に最終エラーになります'),
              value: _alwaysFail,
              onChanged: (value) {
                _recorder.clear();
                setState(() => _alwaysFail = value);
              },
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              key: const Key('retry-restart'),
              onPressed: () {
                _recorder.clear();
                ref.invalidate(automaticRetryProvider(scenario));
              },
              icon: const Icon(Icons.replay),
              label: const Text('試行を最初から開始'),
            ),
            const SizedBox(height: 16),
            Text('試行履歴', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: _recorder,
              builder: (context, child) {
                final attempts = _recorder.attempts.reversed.toList();
                return Column(
                  key: const Key('retry-attempts'),
                  children: [
                    for (final attempt in attempts)
                      ListTile(
                        dense: true,
                        leading: CircleAvatar(child: Text('${attempt.number}')),
                        title: Text('試行${attempt.number}'),
                        trailing: Text(attempt.status.label),
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

Duration? _nextDelay(AsyncValue<String> result, Duration baseDelay) {
  if (!result.retrying) {
    return null;
  }
  final error = result.error;
  if (error is! RetryDemoException) {
    return null;
  }
  return Duration(microseconds: baseDelay.inMicroseconds * error.attempt);
}
