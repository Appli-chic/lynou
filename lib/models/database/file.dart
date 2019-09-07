class LYFile {
  String uid;
  String userId;
  String postId;
  String path;
  String type;
  DateTime createdAt;
  DateTime updatedAt;

  LYFile({
    this.uid,
    this.userId,
    this.postId,
    this.path,
    this.createdAt,
    this.updatedAt,
  });

  factory LYFile.fromJson(Map<String, dynamic> jsonMap) {
    return LYFile(
      uid: jsonMap["uid"],
      userId: jsonMap["userId"],
      postId: jsonMap["postId"],
      path: jsonMap["path"],
      createdAt: jsonMap["createdAt"],
      updatedAt: jsonMap["updatedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'postId': postId,
    'path': path,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}