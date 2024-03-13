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
             'created_at' INTEGER NOT NULL DEFAULT (strftime('%s','now')),
             'updated_at' INTEGER
          )  ''';
    return await database.execute(query);
  }

  Future<int> insertData({required String title}) async {
    final database = await DBHelper().database;

    final query = '''INSERT INTO $tablename(title,created_at) VALUES(?,?)''';

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
        '''SELECT * FROM $tablename ORDER BY COALESCE (updated_at, created_at)''';
    var result = await database.rawQuery(query);
    var datalist = result.map((e) => TaskModel.fromSqliteDatabase(e)).toList();
    return datalist;
  }

  Future<TaskModel> fetchById({required int id}) async {
    final database = await DBHelper().database;
    final query = '''SELECT * FROM $tablename WHERE id = $id''';
    var result = await database.rawQuery(query);
    return TaskModel.fromSqliteDatabase(result.first);
    //  return mydata;
  }

  Future<void> deleteData({required int id}) async {
    final database = await DBHelper().database;
    final query = '''DELETE FROM $tablename WHERE id = $id''';
    await database.rawDelete(query);

    // await database.delete(tablename, where: 'id=?', whereArgs: [id]);
  }

  Future<int> updateData({required int id, required String title}) async {
    final database = await DBHelper().database;
    // return await database.rawUpdate(
    //     'UPDATE $tablename SET title = ?, updated_at = ? WHERE id = ?',
    //     [title, DateTime.now().millisecondsSinceEpoch]);

    final result = await database.update(tablename,
        {'title': title, 'created_at': DateTime.now().millisecondsSinceEpoch},
        where: 'id= ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.rollback);

    return result;
  }
}
