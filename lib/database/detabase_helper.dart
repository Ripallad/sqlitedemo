import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlitedemo/database/task_db.dart';

class DBHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullpath async {
    final dbname = 'taskdb';

    final dbpath = await getDatabasesPath();

    return join(dbpath, dbname);
  }

  Future<Database> _initialize() async {
    final path = await fullpath;
    var database = await openDatabase(path, version: 1, onCreate: create);
    return database;
  }

  Future<void> create(Database database, version) async {
    await TaskDB().createTable(database);
  }
}
