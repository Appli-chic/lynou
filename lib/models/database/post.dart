import 'package:lynou/models/database/file.dart';
import 'package:lynou/models/database/user.dart';
import 'package:lynou/providers/sqlite/post_provider.dart';

class Post {
  int id;
  int userId;
  String text;
  DateTime createdAt;
  DateTime updatedAt;
  List<LYFile> fileList;
  User user;

  Post({
    this.id,
    this.userId,
    this.text,
    this.fileList,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Post.fromJson(Map<String, dynamic> jsonMap) {
    List<LYFile> fileList = [];

    if (jsonMap["Files"] != null) {
      List<dynamic> jsonFileList = jsonMap["Files"];

      for (var jsonFile in jsonFileList) {
        LYFile file = LYFile.fromJson(jsonFile);
        fileList.add(file);
      }
    }

    return Post(
      id: jsonMap["ID"],
      userId: jsonMap["UserId"],
      text: jsonMap["Text"],
      fileList: fileList,
      createdAt: DateTime.parse(jsonMap["CreatedAt"]),
      updatedAt: DateTime.parse(jsonMap["UpdatedAt"]),
      user: User.fromJson(jsonMap["User"]),
    );
  }

  factory Post.fromSqlite(Map<String, dynamic> jsonMap) {
    return Post(
      id: jsonMap[COLUMN_ID],
      userId: jsonMap[COLUMN_USER_ID],
      text: jsonMap[COLUMN_TEXT],
      createdAt: DateTime.parse(jsonMap[COLUMN_CREATED_AT]),
      updatedAt: DateTime.parse(jsonMap[COLUMN_UPDATED_AT]),
    );
  }

  Map<String, dynamic> toSqlite() {
    var map = <String, dynamic>{
      COLUMN_ID: id,
      COLUMN_TEXT: text,
      COLUMN_USER_ID: userId,
      COLUMN_CREATED_AT: createdAt.toIso8601String(),
      COLUMN_UPDATED_AT: updatedAt.toIso8601String(),
    };

    return map;
  }

  Map<String, dynamic> toJson() => {
        'id': userId,
        'text': text,
        'fileList': fileList,
      };
}
