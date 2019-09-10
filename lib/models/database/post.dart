import 'dart:collection';

import 'package:lynou/models/database/file.dart';
import 'package:lynou/models/database/user.dart';

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

      for(var jsonFile in jsonFileList) {
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

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'text': text,
        'fileList': fileList,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
