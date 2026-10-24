import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class TaskRepository {
  final Database database;

  TaskRepository(this.database);

  Future<int> create(String title) async {
    return await database.insert(
      'tasks',
      {
        'title': title,
      },
    );
  }

  Future<List<Task>> getAll() async {
    final result = await database.query(
      'tasks',
      orderBy: 'id DESC',
    );

    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<int> markCompleted(int id) async {
    return await database.update(
      'tasks',
      {
        'is_completed': 1,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    return await database.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}