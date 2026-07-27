enum TodoFilter {
  all('すべて'),
  active('未完了'),
  completed('完了済み');

  const TodoFilter(this.label);

  final String label;
}

class Todo {
  const Todo({required this.id, required this.title, this.isCompleted = false});

  final String id;
  final String title;
  final bool isCompleted;

  Todo copyWith({String? title, bool? isCompleted}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
