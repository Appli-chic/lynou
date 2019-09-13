import 'package:lynou/providers/sqlite/user_provider.dart';

class User {
  int id;
  String email;
  String name;
  String photo;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    this.id,
    this.email,
    this.name,
    this.photo,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> jsonMap) {
    return User(
      id: jsonMap["ID"],
      email: jsonMap["Email"],
      name: jsonMap["Name"],
      photo: jsonMap["Photo"],
      createdAt: DateTime.parse(jsonMap["CreatedAt"]),
      updatedAt: DateTime.parse(jsonMap["UpdatedAt"]),
    );
  }

  factory User.fromSqlite(Map<String, dynamic> jsonMap) {
    return User(
      id: jsonMap[COLUMN_ID],
      email: jsonMap[COLUMN_EMAIL],
      name: jsonMap[COLUMN_NAME],
      photo: jsonMap[COLUMN_PHOTO],
      createdAt: DateTime.parse(jsonMap[COLUMN_CREATED_AT]),
      updatedAt: DateTime.parse(jsonMap[COLUMN_UPDATED_AT]),
    );
  }

  Map<String, dynamic> toSqlite() {
    var map = <String, dynamic>{
      COLUMN_ID: id,
      COLUMN_EMAIL: email,
      COLUMN_NAME: name,
      COLUMN_PHOTO: photo,
      COLUMN_CREATED_AT: createdAt.toIso8601String(),
      COLUMN_UPDATED_AT: updatedAt.toIso8601String(),
    };

    return map;
  }
}