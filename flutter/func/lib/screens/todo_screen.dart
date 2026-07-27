import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';
import '../providers/todo_providers.dart';
import '../widgets/demo_info_card.dart';

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTodo() {
    ref.read(todoListProvider.notifier).add(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(filteredTodosProvider);
    final selectedFilter = ref.watch(todoFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Todoとフィルター')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const DemoInfoCard(
              title: 'Notifier + 派生Provider',
              description:
                  'Todoの変更処理はNotifierに集約し、表示一覧はTodo一覧とフィルターをwatchする'
                  '派生Providerで計算します。',
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('todo-input'),
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: '新しいTodo',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  key: const Key('todo-add'),
                  onPressed: _addTodo,
                  icon: const Icon(Icons.add),
                  label: const Text('追加'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final filter in TodoFilter.values)
                  ChoiceChip(
                    key: Key('todo-filter-${filter.name}'),
                    label: Text(filter.label),
                    selected: selectedFilter == filter,
                    onSelected: (_) {
                      ref.read(todoFilterProvider.notifier).setFilter(filter);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const _TodoStats(),
            const SizedBox(height: 8),
            if (todos.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('この条件に一致するTodoはありません')),
                ),
              )
            else
              for (final todo in todos)
                Card(
                  key: Key('todo-${todo.id}'),
                  child: ListTile(
                    leading: Checkbox(
                      key: Key('todo-toggle-${todo.id}'),
                      value: todo.isCompleted,
                      onChanged: (_) {
                        ref.read(todoListProvider.notifier).toggle(todo.id);
                      },
                    ),
                    title: Text(
                      todo.title,
                      style: todo.isCompleted
                          ? const TextStyle(
                              decoration: TextDecoration.lineThrough,
                            )
                          : null,
                    ),
                    trailing: IconButton(
                      key: Key('todo-remove-${todo.id}'),
                      tooltip: '削除',
                      onPressed: () {
                        ref.read(todoListProvider.notifier).remove(todo.id);
                      },
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _TodoStats extends ConsumerWidget {
  const _TodoStats();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedCount = ref.watch(
      todoListProvider.select(
        (todos) => todos.where((todo) => todo.isCompleted).length,
      ),
    );
    final totalCount = ref.watch(todoListProvider).length;

    return Text(
      '全$totalCount件 / 完了$completedCount件（完了件数はselectで監視）',
      key: const Key('todo-stats'),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
