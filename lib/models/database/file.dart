class LYFile {
  String id;
  String userId;
  String postId;
  String name;
  int type;
  DateTime createdAt;
  DateTime updatedAt;

  LYFile({
    this.id,
    this.userId,
    this.postId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory LYFile.fromJson(Map<String, dynamic> jsonMap) {
    return LYFile(
      id: jsonMap["Id"],
      userId: jsonMap["UserId"],
      postId: jsonMap["PostId"],
      name: jsonMap["Name"],
      createdAt: jsonMap["CreatedAt"],
      updatedAt: jsonMap["UpdatedAt"],
    );
  }
}