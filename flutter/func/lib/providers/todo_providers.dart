import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/todo.dart';

class TodoListNotifier extends Notifier<List<Todo>> {
  int _nextId = 3;

  @override
  List<Todo> build() => const [
    Todo(id: '1', title: 'RiverpodのProviderを読む'),
    Todo(id: '2', title: 'selectの動作を試す', isCompleted: true),
  ];

  void add(String title) {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      return;
    }

    state = [...state, Todo(id: '${_nextId++}', title: normalizedTitle)];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          todo.copyWith(isCompleted: !todo.isCompleted)
        else
          todo,
    ];
  }

  void remove(String id) {
    state = state.where((todo) => todo.id != id).toList(growable: false);
  }
}

class TodoFilterNotifier extends Notifier<TodoFilter> {
  @override
  TodoFilter build() => TodoFilter.all;

  void setFilter(TodoFilter filter) => state = filter;
}

final todoListProvider = NotifierProvider<TodoListNotifier, List<Todo>>(
  TodoListNotifier.new,
  name: 'todoList',
);

final todoFilterProvider = NotifierProvider<TodoFilterNotifier, TodoFilter>(
  TodoFilterNotifier.new,
  name: 'todoFilter',
);

final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoListProvider);
  final filter = ref.watch(todoFilterProvider);

  return switch (filter) {
    TodoFilter.all => todos,
    TodoFilter.active =>
      todos.where((todo) => !todo.isCompleted).toList(growable: false),
    TodoFilter.completed =>
      todos.where((todo) => todo.isCompleted).toList(growable: false),
  };
}, name: 'filteredTodos');
