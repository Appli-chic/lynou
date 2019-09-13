import 'package:lynou/models/database/post.dart';
import 'package:lynou/providers/sqlite/file_provider.dart' as f;
import 'package:lynou/providers/sqlite/user_provider.dart' as u;
import 'package:lynou/utils/sqlite.dart';

const TABLE_POST = "Post";
const COLUMN_ID = "id";
const COLUMN_TEXT = "text";
const COLUMN_CREATED_AT = "createdAt";
const COLUMN_UPDATED_AT = "updatedAt";
const COLUMN_USER_ID = "userId";

class PostProvider {
  static String createTable() {
    return 'CREATE TABLE $TABLE_POST ($COLUMN_ID INTEGER PRIMARY KEY, $COLUMN_TEXT TEXT, $COLUMN_USER_ID INTEGER, '
        '$COLUMN_CREATED_AT DATETIME, $COLUMN_UPDATED_AT DATETIME, FOREIGN KEY($COLUMN_USER_ID) REFERENCES ${u.TABLE_USER}(${u.COLUMN_ID}))';
  }

  static Future<void> save(Post post) async {
    var sqlite = Sqlite();
    await sqlite.open();

    var postFromSqlite = await fetchById(post.id);
    await sqlite.open();

    if(postFromSqlite != null) {
      // Update the existing entry
      await sqlite.update(TABLE_POST, post.toSqlite(), where: "$COLUMN_ID = ?", whereArgs: [post.id]);
    } else {
      // Add a new entry
      await sqlite.insert(TABLE_POST, post.toSqlite());
    }

    await sqlite.close();
  }

  static Future<Post> fetchById(int postId) async {
    var sqlite = Sqlite();
    await sqlite.open();
    var dataList = await sqlite.fetchData(TABLE_POST, where: '$COLUMN_ID = ?', whereArgs: [postId]);
    await sqlite.close();

    if(dataList.isNotEmpty) {
      var user = Post.fromSqlite(dataList[0]);
      return user;
    }

    return null;
  }

  /// Find the posts for the wall
  static Future<List<Post>> fetchWallPosts() async {
    var postList = List<Post>();

    var sqlite = Sqlite();
    await sqlite.open();
    var dataList = await sqlite.fetchData(TABLE_POST, limit: 10, orderBy: '$COLUMN_CREATED_AT desc');
    await sqlite.close();

    for(var data in dataList) {
      var post = Post.fromSqlite(data);
      post.user = await u.UserProvider.findById(post.userId);
      post.fileList = await f.FileProvider.fetchByPost(post.id);

      postList.add(post);
    }

    return postList;
  }
}
