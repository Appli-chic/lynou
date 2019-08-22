import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String email;
  String name;
  Timestamp createdAt;
  Timestamp updatedAt;

  User({
    this.uid,
    this.email,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> jsonMap) {
    return new User(
      uid: jsonMap["uid"],
      email: jsonMap["email"],
      name: jsonMap["name"],
      createdAt: jsonMap["createdAt"],
      updatedAt: jsonMap["updatedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}