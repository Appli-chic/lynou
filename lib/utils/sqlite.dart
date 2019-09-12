import 'package:lynou/models/database/post.dart';
import 'package:lynou/models/database/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Sqlite {
  Database db;

  /// Open and create the database with the structure
  open() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'local.db');

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // Create the tables
      await db.execute(User.createTable());
      await db.execute(Post.createTable());
    });
  }

  /// Close the database when the queries are done
  close() async {
    await db.close();
  }

  /// Insert data in the local database
  insert(String data) async {
    await db.transaction((txn) async {
      try {
        await txn.rawInsert(data);
      } catch (e) {}
    });
  }

  /// Fetch all rows in a table
  Future<List<Map<String, dynamic>>> fetchData(String tableName) async {
    return await db.query(tableName);
  }
}
