import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'todo_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() => _instance;
  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) => db.execute(
        "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, isCompleted INTEGER)"
      ),
    );
  }

  // Create
  Future<int> insertTodo(Todo todo) async {
    Database db = await database;
    return await db.insert('todos', todo.toMap());
  }

  // Read
  Future<List<Todo>> getTodos({bool? isCompleted}) async {
    Database db = await database;
    List<Map<String, dynamic>> maps;
    
    if (isCompleted != null) {
      maps = await db.query(
        'todos',
        where: 'isCompleted = ?',
        whereArgs: [isCompleted ? 1 : 0],
        orderBy: "id DESC",
      );
    } else {
      maps = await db.query('todos', orderBy: "id DESC");
    }
    
    return List.generate(maps.length, (i) => Todo.fromMap(maps[i]));
  }

  // Update
  Future<int> updateTodo(Todo todo) async {
    Database db = await database;
    return await db.update('todos', todo.toMap(), 
      where: 'id = ?', whereArgs: [todo.id]);
  }

  // Delete
  Future<int> deleteTodo(int id) async {
    Database db = await database;
    return await db.delete('todos', 
      where: 'id = ?', whereArgs: [id]);
  }
}