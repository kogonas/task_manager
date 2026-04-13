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

  // Convert Firestore Document