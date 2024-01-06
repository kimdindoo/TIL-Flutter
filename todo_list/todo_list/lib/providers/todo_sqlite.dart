import 'package:sqflite/sqflite.dart';

import '../models/todo_model.dart';

class TodoSqlite {
  late Database db;

  Future initDb() async {
    // MissingPluginError 발생하면 앱 중지 / 앱 삭제 후 다시 빌드
    db = await openDatabase('my_db.db');
    await db.execute(
      'CREATE TABLE IF NOT EXISTS MyTodo (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, description TEXT)',
    );
  }

  Future<List<Todo>> getTodos() async {
    List<Todo> todos = [];
    List<Map> maps =
        await db.query('MyTodo', columns: ['id', 'title', 'description']);

    for (var map in maps) {
      todos.add(Todo.fromMap(map as Map<String, dynamic>));
    }

    return todos;
  }

  Future<Todo?> getTodo(int id) async {
    List<Map> map = await db.query(
      'MyTOdo',
      columns: ['id', 'title', 'description'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (map.isNotEmpty) {
      return Todo.fromMap(map[0] as Map<String, dynamic>);
    }
    return null;
  }

  Future addTodo(Todo todo) async {
    int id = await db.insert('MyTodo', todo.toMap());
  }

  Future deleteTodo(int id) async {
    await db.delete(
      'MyTodo',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future updateTodo(Todo todo) async {
    await db.update(
      'MyTodo',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }
}
