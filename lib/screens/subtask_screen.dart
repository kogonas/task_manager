import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class SubtaskScreen extends StatefulWidget {
  final Task task;

  const SubtaskScreen({super.key, required this.task});

  @override
  State<SubtaskScreen> createState() => _SubtaskScreenState();
}

class _SubtaskScreenState extends State<SubtaskScreen> {
  final TextEditingController _controller = TextEditingController();
  final TaskService _taskService = TaskService();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addSubtask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _taskService.addSubtask(widget.task.id, text);
    _controller.clear();
  }

  void _deleteSubtask(String subtask) {
    _taskService.deleteSubtask(widget.task.id, subtask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add subtask input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "Add subtask",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addSubtask,
                  child: const Text("Add"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Subtask list
            Expanded(
              child: StreamBuilder<Task>(
                stream: FirebaseFirestore.instance
                    .collection('tasks')
                    .doc(widget.task.id)
                    .snapshots()
                    .map((doc) => Task.fromMap(doc.id, doc.data()!)),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final updatedTask = snapshot.data!;
                  final subtasks = updatedTask.subtasks;

                  if (subtasks.isEmpty) {
                    return const Center(child: Text("No subtasks yet."));
                  }

                  return ListView.builder(
                    itemCount: subtasks.length,
                    itemBuilder: (context, index) {
                      final subtask = subtasks[index];

                      return ListTile(
                        title: Text(subtask),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteSubtask(subtask),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
