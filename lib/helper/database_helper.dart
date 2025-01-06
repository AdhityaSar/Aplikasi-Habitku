import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:aplikasi_habitku/models/task_model.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'tasks';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnDescription = 'description';
  static final columnIcon = 'icon';
  static final columnDate = 'date';
  static final columnTime = 'time';
  static final columnCategory = 'category';

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Create database table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT NOT NULL,
        $columnIcon INTEGER NOT NULL,
        $columnDate TEXT NOT NULL,
        $columnTime TEXT NOT NULL,
        $columnCategory TEXT NOT NULL
      )
    ''');
  }

  // Insert a task
  Future<int> insert(Task task) async {
    Database db = await database;
    return await db.insert(table, task.toMap());
  }

  // Query all rows
  Future<List<Task>> queryAllRows() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // Query tasks by date
  Future<List<Task>> queryTasksByDate(DateTime date) async {
    Database db = await database;

    String formattedDate = "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnDate = ?',
      whereArgs: [formattedDate],
    );

    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // Update a task
  Future<int> update(Task task) async {
    Database db = await database;
    return await db.update(
      table,
      task.toMap(),
      where: '$columnId = ?',
      whereArgs: [task.id],
    );
  }

  // Delete a task
  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
