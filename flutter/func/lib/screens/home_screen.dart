import 'package:flutter/material.dart';

import 'async_demo_screen.dart';
import 'async_value_flags_screen.dart';
import 'automatic_retry_screen.dart';
import 'background_notification_screen.dart';
import 'counter_screen.dart';
import 'family_override_screen.dart';
import 'lifecycle_screen.dart';
import 'provider_observer_screen.dart';
import 'ref_mounted_screen.dart';
import 'stream_demo_screen.dart';
import 'todo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final destinations = [
      _DemoDestination(
        keyName: 'open-background-notification-demo',
        icon: Icons.notifications_active_outlined,
        title: 'バックグラウンド通知',
        subtitle: 'バックグラウンド移動から5秒後に通知',
        builder: (_) => const BackgroundNotificationScreen(),
      ),
      _DemoDestination(
        keyName: 'open-counter-demo',
        icon: Icons.calculate_outlined,
        title: '状態と派生値',
        subtitle: 'NotifierProvider / watch / read / select',
        builder: (_) => const CounterScreen(),
      ),
      _DemoDestination(
        keyName: 'open-todo-demo',
        icon: Icons.checklist_outlined,
        title: 'Todoとフィルター',
        subtitle: '不変モデル / 派生Provider / 絞り込み',
        builder: (_) => const TodoScreen(),
      ),
      _DemoDestination(
        keyName: 'open-async-demo',
        icon: Icons.cloud_sync_outlined,
        title: '非同期状態',
        subtitle: 'AsyncNotifier / loading / data / error',
        builder: (_) => const AsyncDemoScreen(),
      ),
      _DemoDestination(
        keyName: 'open-family-demo',
        icon: Icons.account_tree_outlined,
        title: 'FamilyとOverride',
        subtitle: '引数付きProvider / スコープ / invalidate',
        builder: (_) => const FamilyOverrideScreen(),
      ),
      _DemoDestination(
        keyName: 'open-stream-demo',
        icon: Icons.sensors_outlined,
        title: 'Streamとリアルタイム更新',
        subtitle: 'StreamProvider / 購読 / エラー',
        builder: (_) => const StreamDemoScreen(),
      ),
      _DemoDestination(
        keyName: 'open-lifecycle-demo',
        icon: Icons.recycling_outlined,
        title: 'Providerライフサイクル',
        subtitle: 'autoDispose / keepAlive / onDispose',
        builder: (_) => const LifecycleScreen(),
      ),
      _DemoDestination(
        keyName: 'open-observer-demo',
        icon: Icons.monitor_heart_outlined,
        title: 'ProviderObserverログ',
        subtitle: '生成 / 更新 / 失敗 / 破棄',
        builder: (_) => const ProviderObserverScreen(),
      ),
      _DemoDestination(
        keyName: 'open-retry-demo',
        icon: Icons.restart_alt,
        title: '自動リトライ',
        subtitle: 'retry / retrying / バックオフ',
        builder: (_) => const AutomaticRetryScreen(),
      ),
      _DemoDestination(
        keyName: 'open-async-flags-demo',
        icon: Icons.flag_outlined,
        title: 'AsyncValue状態判定',
        subtitle: 'isRefreshing / isReloading / 前回値',
        builder: (_) => const AsyncValueFlagsScreen(),
      ),
      _DemoDestination(
        keyName: 'open-ref-mounted-demo',
        icon: Icons.health_and_safety_outlined,
        title: 'Ref.mounted',
        subtitle: 'autoDispose / await / 安全な終了',
        builder: (_) => const RefMountedScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod Playground')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Riverpodの機能を触って試す',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('各カードを開き、ボタン操作による状態変化とProviderの役割を確認できます。'),
            const SizedBox(height: 16),
            for (final destination in destinations)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    key: Key(destination.keyName),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: destination.builder),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(destination.icon, size: 32),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  destination.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(destination.subtitle),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DemoDestination {
  const _DemoDestination({
    required this.keyName,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.builder,
  });

  final String keyName;
  final IconData icon;
  final String title;
  final String subtitle;
  final WidgetBuilder builder;
}
