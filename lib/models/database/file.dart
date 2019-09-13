import 'package:lynou/providers/sqlite/file_provider.dart';

const int TYPE_IMAGE = 0;
const int TYPE_VIDEO = 1;

class LYFile {
  int id;
  int postId;
  String name;
  String thumbnail;
  int type;
  DateTime createdAt;
  DateTime updatedAt;

  LYFile({
    this.id,
    this.postId,
    this.name,
    this.type,
    this.thumbnail,
    this.createdAt,
    this.updatedAt,
  });

  factory LYFile.fromJson(Map<String, dynamic> jsonMap) {
    return LYFile(
      id: jsonMap["ID"],
      postId: jsonMap["PostId"],
      type: jsonMap["Type"],
      name: jsonMap["Name"],
      thumbnail: jsonMap["Thumbnail"],
      createdAt: DateTime.parse(jsonMap["CreatedAt"]),
      updatedAt: DateTime.parse(jsonMap["UpdatedAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
    'postId': postId,
    'type': type,
    'name': name,
    'thumbnail': thumbnail,
  };

  factory LYFile.fromSqlite(Map<String, dynamic> jsonMap) {
    return LYFile(
      id: jsonMap[COLUMN_ID],
      name: jsonMap[COLUMN_NAME],
      thumbnail: jsonMap[COLUMN_THUMBNAIL],
      type: jsonMap[COLUMN_TYPE],
      createdAt: DateTime.parse(jsonMap[COLUMN_CREATED_AT]),
      updatedAt: DateTime.parse(jsonMap[COLUMN_UPDATED_AT]),
      postId: jsonMap[COLUMN_POST_ID],
    );
  }

  Map<String, dynamic> toSqlite() {
    var map = <String, dynamic>{
      COLUMN_ID: id,
      COLUMN_NAME: name,
      COLUMN_THUMBNAIL: thumbnail,
      COLUMN_TYPE: type,
      COLUMN_CREATED_AT: createdAt.toIso8601String(),
      COLUMN_UPDATED_AT: updatedAt.toIso8601String(),
      COLUMN_POST_ID: postId,
    };

    return map;
  }
}