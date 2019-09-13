
import 'package:lynou/models/database/file.dart';
import 'package:lynou/providers/sqlite/post_provider.dart' as p;
import 'package:lynou/utils/sqlite.dart';

const TABLE_FILE = "File";
const COLUMN_ID = "id";
const COLUMN_NAME = "name";
const COLUMN_THUMBNAIL = "thumbnail";
const COLUMN_TYPE = "type";
const COLUMN_CREATED_AT = "createdAt";
const COLUMN_UPDATED_AT = "updatedAt";
const COLUMN_POST_ID = "postId";

class FileProvider {
  static String createTable() {
    return 'CREATE TABLE $TABLE_FILE ($COLUMN_ID INTEGER PRIMARY KEY, $COLUMN_NAME TEXT, $COLUMN_THUMBNAIL TEXT, $COLUMN_TYPE INTEGER, '
        '$COLUMN_POST_ID INTEGER, $COLUMN_CREATED_AT DATETIME, $COLUMN_UPDATED_AT DATETIME, '
        'FOREIGN KEY($COLUMN_POST_ID) REFERENCES ${p.TABLE_POST}(${p.COLUMN_ID}))';
  }

  static Future<void> save(LYFile file) async {
    var sqlite = Sqlite();
    await sqlite.open();

    var postFromSqlite = await fetchById(file.id);
    await sqlite.open();

    if(postFromSqlite != null) {
      // Update the existing entry
      await sqlite.update(TABLE_FILE, file.toSqlite(), where: "$COLUMN_ID = ?", whereArgs: [file.id]);
    } else {
      // Add a new entry
      await sqlite.insert(TABLE_FILE, file.toSqlite());
    }

    await sqlite.close();
  }

  static Future<LYFile> fetchById(int fileId) async {
    var sqlite = Sqlite();
    await sqlite.open();
    var dataList = await sqlite.fetchData(TABLE_FILE, where: '$COLUMN_ID = ?', whereArgs: [fileId]);
    await sqlite.close();

    if(dataList.isNotEmpty) {
      var user = LYFile.fromSqlite(dataList[0]);
      return user;
    }

    return null;
  }

  static Future<List<LYFile>> fetchByPost(int postId) async {
    var fileList = List<LYFile>();
    var sqlite = Sqlite();
    await sqlite.open();
    var dataList = await sqlite.fetchData(TABLE_FILE, where: '$COLUMN_POST_ID = ?', whereArgs: [postId]);
    await sqlite.close();

    for(var data in dataList) {
      var file = LYFile.fromSqlite(data);
      fileList.add(file);
    }

    return fileList;
  }
}