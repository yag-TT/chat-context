import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/family_message.dart';
import '../providers/family_providers.dart';
import '../widgets/demo_info_card.dart';

class FamilyOverrideScreen extends ConsumerStatefulWidget {
  const FamilyOverrideScreen({super.key});

  @override
  ConsumerState<FamilyOverrideScreen> createState() =>
      _FamilyOverrideScreenState();
}

class _FamilyOverrideScreenState extends ConsumerState<FamilyOverrideScreen> {
  final _controller = TextEditingController(text: 'Riverpod');
  String _name = 'Riverpod';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final normalMessage = ref.watch(greetingProvider(_name));

    return Scaffold(
      appBar: AppBar(title: const Text('FamilyとOverride')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const DemoInfoCard(
              title: 'Provider.family + ProviderScope',
              description:
                  'familyへ名前を渡して結果を分離します。下のOverride領域だけ環境Providerを'
                  '差し替えるため、同じ入力でも異なるメッセージになります。',
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('family-name-input'),
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: '名前',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _applyName(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  key: const Key('family-apply'),
                  onPressed: _applyName,
                  child: const Text('適用'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _MessageCard(
              key: const Key('normal-family-card'),
              title: '通常スコープ',
              message: normalMessage,
              onInvalidate: () => ref.invalidate(greetingProvider(_name)),
            ),
            const SizedBox(height: 12),
            ProviderScope(
              key: ValueKey('override-scope-$_name'),
              overrides: [
                environmentProvider.overrideWithValue('Override環境'),
                greetingProvider(_name).overrideWith((ref) {
                  final environment = ref.watch(environmentProvider);
                  return createFamilyMessage(
                    environment: environment,
                    name: _name,
                  );
                }),
              ],
              child: _OverriddenMessage(name: _name),
            ),
          ],
        ),
      ),
    );
  }

  void _applyName() {
    setState(() {
      _name = _controller.text;
    });
  }
}

class _OverriddenMessage extends ConsumerWidget {
  const _OverriddenMessage({required this.name});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(greetingProvider(name));

    return _MessageCard(
      key: const Key('override-family-card'),
      title: 'Overrideスコープ',
      message: message,
      onInvalidate: () => ref.invalidate(greetingProvider(name)),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    super.key,
    required this.title,
    required this.message,
    required this.onInvalidate,
  });

  final String title;
  final FamilyMessage message;
  final VoidCallback onInvalidate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message.text),
            const SizedBox(height: 4),
            Text(
              '評価時刻: ${message.evaluatedAt.toLocal().toIso8601String()}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: onInvalidate,
              icon: const Icon(Icons.refresh),
              label: const Text('このProviderを再評価'),
            ),
          ],
        ),
      ),
    );
  }
}
