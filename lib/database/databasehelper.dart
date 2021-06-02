import 'dart:io';
import 'package:faith_sample/models/todomodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;
  var table = "todoTable";
  var columnId = "id";
  var columnTitle = "title";
  var columnDescription = "description";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'maindb.db');
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $table($columnId INTEGER PRIMARY KEY, $columnTitle TEXT, $columnDescription TEXT)");
  }

  Future<int> createTodo(TodoModel todoModel) async {
    var dbClient = await db;
    int res = await dbClient.insert("$table", todoModel.toMap());
    return res;
  }

  Future<List> getAllTodo() async {
    var dbClient = await db;
    List res = await dbClient.rawQuery("SELECT * FROM $table");
    return res.toList();
  }

  Future<TodoModel> getTodo(int id) async {
    var dbClient = await db;
    var res =
        await dbClient.rawQuery("SELECT * FROM $table WHERE $columnId = $id");
    if (res.length == 0) {
      return null;
    } else {
      return TodoModel.fromMap(res.first);
    }
  }

  Future<int> deleteTodo(int id) async {
    var dbClient = await db;
    var res = await dbClient
        .delete("$table", where: "$columnId = ?", whereArgs: [id]);
    return res;
  }

  Future<int> updateTodo(TodoModel todoModel) async {
    var dbClient = await db;
    var res = await dbClient.update("$table", todoModel.toMap(),
        where: "$columnId = ?", whereArgs: [todoModel.id]);
    return res;
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
