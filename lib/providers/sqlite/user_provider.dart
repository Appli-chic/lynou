import 'package:lynou/models/database/user.dart';
import 'package:lynou/utils/sqlite.dart';

const TABLE_USER = "User";
const COLUMN_ID = "id";
const COLUMN_EMAIL = "email";
const COLUMN_NAME = "name";
const COLUMN_PHOTO = "photo";
const COLUMN_CREATED_AT = "createdAt";
const COLUMN_UPDATED_AT = "updatedAt";

class UserProvider {
  static String createTable() {
    return 'CREATE TABLE $TABLE_USER ($COLUMN_ID INTEGER PRIMARY KEY, $COLUMN_EMAIL TEXT, $COLUMN_NAME TEXT, '
        '$COLUMN_PHOTO, TEXT, $COLUMN_CREATED_AT DATETIME, $COLUMN_UPDATED_AT DATETIME)';
  }

  static Future<void> save(User user) async {
    var sqlite = Sqlite();
    await sqlite.open();

    var userFromSqlite = await findById(user.id);
    await sqlite.open();

    if(userFromSqlite != null) {
      // Update the existing entry
      await sqlite.update(TABLE_USER, user.toSqlite(), where: "$COLUMN_ID = ?", whereArgs: [user.id]);
    } else {
      // Add a new entry
      await sqlite.insert(TABLE_USER, user.toSqlite());
    }

    await sqlite.close();
  }

  /// Find the user linked to this [userId]
  static Future<User> findById(int userId) async {
    var sqlite = Sqlite();
    await sqlite.open();
    var dataList = await sqlite.fetchData(TABLE_USER, where: '$COLUMN_ID = ?', whereArgs: [userId]);
    await sqlite.close();

    if(dataList.isNotEmpty) {
      var user = User.fromSqlite(dataList[0]);
      return user;
    }

    return null;
  }
}
