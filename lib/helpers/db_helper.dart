import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String dbPath = path.join(appDir.path, 'places.db');
    return await sql.openDatabase(dbPath,
        onCreate: (db, version) async => await db.execute(
            '''CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT);'''),
        version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return await db.query(table);
  }
}
