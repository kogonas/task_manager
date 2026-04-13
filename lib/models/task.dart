class Task {
  final String id;
  final String name;
  final bool isComplete;
  final List<String> subtasks;

  Task({
    required this.id,
    required this.name,
    required this.isComplete,
    required this.subtasks,
  });

  // Convert Task → Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isComplete': isComplete,
      'subtasks': subtasks,
    };
  }

  // Convert Firestore Document → Task
  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      name: map['name'] ?? '',
      isComplete: map['isComplete'] ?? false,
      subtasks: List<String>.from(map['subtasks'] ?? []),
    );
  }

  // Create a modified copy (used for updates)
  Task copyWith({
    String? id,
    String? name,
    bool? isComplete,
    List<String>? subtasks,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      isComplete: isComplete ?? this.isComplete,
      subtasks: subtasks ?? this.subtasks,
    );
  }
}
