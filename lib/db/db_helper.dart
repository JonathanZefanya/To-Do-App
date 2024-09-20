import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = 'tasks';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'task.db';
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE $_tableName('
              'id INTEGER PRIMARY KEY AUTOINCREMENT,'
              'title TEXT,'
              'note TEXT,'
              'date TEXT,'
              'startTime TEXT,'
              'endTime TEXT,'
              'remind INTEGER,'
              'repeat TEXT,'
              'color INTEGER,'
              'isCompleted INTEGER'
              ');');
        });
      } catch (e) {}
    }
  }

  //insert the task
  static Future<int> insert(Task? task) async {
    return await _db!.insert(_tableName, task!.toJison());
  }

  static Future<int> delete(Task task) async {
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task!.id]);
  }

  static Future<int> update(int id) async {
    return await _db!.rawUpdate('''
   
   UPDATE tasks SET isCompleted = ? WHERE ID = ?
  
''', [1, id]);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }
}
