import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/task.dart';
import '../repositories/task_repositories.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController controller = TextEditingController();

  late Database database;
  late TaskRepository repository;

  List<Task> tasks = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    try {
      database = await DatabaseHelper.openTaskDatabase();
      repository = TaskRepository(database);

      await loadTasks();
    } catch (e) {
      showMessage("Database Error");
    }
  }

  Future<void> loadTasks() async {
    try {
      final data = await repository.getAll();

      setState(() {
        tasks = data;
        loading = false;
      });
    } catch (e) {
      showMessage("Failed to load tasks.");
    }
  }

  Future<void> addTask() async {
    final title = controller.text.trim();

    if (title.isEmpty) {
      showMessage("Task title cannot be empty.");
      return;
    }

    try {
      await repository.create(title);

      controller.clear();

      await loadTasks();
    } catch (e) {
      showMessage("Failed to save task.");
    }
  }

  Future<void> completeTask(int id) async {
    try {
      await repository.markCompleted(id);
      await loadTasks();
    } catch (e) {
      showMessage("Failed to update task.");
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await repository.delete(id);
      await loadTasks();
    } catch (e) {
      showMessage("Failed to delete task.");
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Local Task Manager")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Task Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addTask,
                child: const Text("Add Task"),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : tasks.isEmpty
                  ? const Center(child: Text("No tasks available."))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];

                        return Card(
                          child: ListTile(
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Text(
                              task.isCompleted ? "Completed" : "Pending",
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!task.isCompleted)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    ),
                                    onPressed: () => completeTask(task.id!),
                                  ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => deleteTask(task.id!),
                                ),
                              ],
                            ),
                          ),
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
