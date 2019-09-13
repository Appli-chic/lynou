import 'dart:io';

import 'package:lynou/providers/sqlite/file_provider.dart';
import 'package:lynou/providers/sqlite/post_provider.dart';
import 'package:lynou/providers/sqlite/user_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Sqlite {
  Database db;

  deleteDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'local.db');
    var file = File(path);
    file.delete();
  }

  /// Open and create the database with the structure
  open() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'local.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // Create the tables
      await db.execute(FileProvider.createTable());
      await db.execute(UserProvider.createTable());
      await db.execute(PostProvider.createTable());
    });
  }

  /// Close the database when the queries are done
  close() async {
    await db.close();
  }

  /// Insert data in the local database
  insert(String tableName, Map<String, dynamic> values) async {
    return await db.insert(tableName, values);
  }

  /// Update the specific row
  update(
    String tableName,
    Map<String, dynamic> values, {
    String where,
    List<dynamic> whereArgs,
  }) async {
    return await db.update(tableName, values,
        where: where, whereArgs: whereArgs);
  }

  /// Fetch all rows in a table
  Future<List<Map<String, dynamic>>> fetchData(
    String tableName, {
    String where,
    List<dynamic> whereArgs,
    String orderBy,
    int limit,
  }) async {
    return await db.query(tableName,
        where: where, whereArgs: whereArgs, orderBy: orderBy, limit: limit);
  }
}
