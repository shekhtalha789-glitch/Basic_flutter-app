class Task {
  final String id;
  final String title;
  final bool done;

  Task({
    required this.id,
    required this.title,
    this.done = false,
  });

  bool get isComplete => done;

  Task copyWith({
    String? id,
    String? title,
    bool? isComplete,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      done: isComplete ?? this.done,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'done': done};

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String? ?? '', // fallback for old data without id
        title: json['title'] as String,
        done: json['done'] as bool? ?? false,
      );
}
