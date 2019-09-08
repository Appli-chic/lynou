import 'package:lynou/models/database/file.dart';

class Post {
  int id;
  String userId;
  String text;
  DateTime createdAt;
  DateTime updatedAt;
  List<LYFile> fileList;

  // For displaying
  String name;

  Post({
    this.id,
    this.userId,
    this.text,
    this.fileList,
    this.createdAt,
    this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> jsonMap) {
    List<LYFile> fileList = [];

    if (jsonMap["fileList"] != null) {
      fileList = List<LYFile>.from(jsonMap["fileList"]);
    }

    return Post(
      id: jsonMap["id"],
      userId: jsonMap["user_id"],
      text: jsonMap["text"],
      fileList: fileList,
      createdAt: jsonMap["created_at"],
      updatedAt: jsonMap["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'text': text,
        'fileList': fileList,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
