import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  final CollectionReference tasksRef =
      FirebaseFirestore.instance.collection('tasks');

  // CREATE — Add a new task
  Future<void> addTask(String name) async {
    await tasksRef.add({
      'name': name,
      'isComplete': false,
      'subtasks': [],
    });
  }

  // READ — Stream all tasks in real time
  Stream<List<Task>> streamTasks() {
    return tasksRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // UPDATE — Toggle completion or update fields
  Future<void> updateTask(Task task) async {
    await tasksRef.doc(task.id).update(task.toMap());
  }

  // DELETE — Remove a task
  Future<void> deleteTask(String id) async {
    await tasksRef.doc(id).delete();
  }

  // SUBTASKS — Add a subtask
  Future<void> addSubtask(String taskId, String subtask) async {
    await tasksRef.doc(taskId).update({
      'subtasks': FieldValue.arrayUnion([subtask]),
    });
  }

  // SUBTASKS — Remove a subtask
  Future<void> deleteSubtask(String taskId, String subtask) async {
    await tasksRef.doc(taskId).update({
      'subtasks': FieldValue.arrayRemove([subtask]),
    });
  }
}
