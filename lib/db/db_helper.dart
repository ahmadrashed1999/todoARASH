import 'package:sqflite/sqflite.dart';
import 'package:testapp/models/task.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = 'tasks';
  static Future<void> initDB() async {
    if (_db != null) {
      return;
    } else {
      try {
        String path = await getDatabasesPath() + '/tasks.db';
        print(path);
        _db = await openDatabase(
          path,
          version: _version,
          onCreate: (db, version) {
            print('====create done');
            db.execute('''
                CREATE TABLE $_tableName (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                 title STRING,
                 note TEXT,
                  isCompleted INTEGER,
                 date STRING,
                 startTime STRING,
                 endTime STRING,
                  color INTEGER,
                 remind INTEGER
                 ,repeat STRING)''');

            print("===dione");
          },
        );
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insertToDb(Task? task) async {
    print('insert==========================');
    try {
      var id = await _db!.insert(
        _tableName,
        task!.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } catch (e) {
      print(e.toString() + 'sssssssssssssssssssssssssssssssssssss');
      return 0;
    }
  }

  static Future<int> update(id) async {
    return await _db!.rawUpdate('''
    UPDATE $_tableName SET
     isCompleted  = ?
     where id = ?

''', [1, id]);
  }

  static Future<int> delete(Task task) async {
    return await _db!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
    static Future<int> deleteAll() async {
    return await _db!.delete(
      _tableName,
     );
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(
      _tableName,
    );
  }
}
