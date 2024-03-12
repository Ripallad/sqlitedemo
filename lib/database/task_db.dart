import 'package:sqflite/sqflite.dart';
import 'package:sqlitedemo/database/detabase_helper.dart';
import 'package:sqlitedemo/taskModel.dart';

class TaskDB {
  final tablename = 'task';
  Future<void> createTable(Database database) async {
    final query = '''
          CREATE TABLE IF NOT EXISTS $tablename(
             'id' INTEGER PRIMARY KEY AUTOINCREMENT,
             'title' TEXT NOT NULL,
             'created_at' INTEGER NOT NULL DEFAULT (strtime('%s','now')),
             'updated_at' INTEGER
          )  ''';
    return await database.execute(query);
  }

  Future<int> insertData({required String title}) async {
    final database = await DBHelper().database;

    final query = '''INSERT INTO $tablename VALUES(title,created_at)''';

    var result = await database
        .rawInsert(query, [title, DateTime.now().millisecondsSinceEpoch]);

    // await database.insert(
    //   tablename,
    //   {'title': title, 'created_at': DateTime.now().millisecondsSinceEpoch},
    //   conflictAlgorithm: ConflictAlgorithm.replace,
    // );

    return result;
  }

  Future<List<TaskModel>> fetchAllData() async {
    final database = await DBHelper().database;
    final query =
        '''SELECT * FROM $tablename ORDER BY COALSCE (updated_at, created_at)''';
    var result = await database.rawQuery(query);
    var datalist = result.map((e) => TaskModel.fromSqliteDatabase(e)).toList();
    return datalist;
  }
}
