import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String uid;
  String userId;
  String text;
  Timestamp createdAt;
  Timestamp updatedAt;

  // For displaying
  String name;

  Post({
    this.uid,
    this.userId,
    this.text,
    this.createdAt,
    this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> jsonMap) {
    return new Post(
      uid: jsonMap["uid"],
      userId: jsonMap["userId"],
      text: jsonMap["text"],
      createdAt: jsonMap["createdAt"],
      updatedAt: jsonMap["updatedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'text': text,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
