class Post {
  String uid;
  String userId;
  String text;
  DateTime createdAt;
  DateTime updatedAt;
  List<String> fileList;

  // For displaying
  String name;

  Post({
    this.uid,
    this.userId,
    this.text,
    this.fileList,
    this.createdAt,
    this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> jsonMap) {
    List<String> fileList = [];

    if (jsonMap["fileList"] != null) {
      fileList = List<String>.from(jsonMap["fileList"]);
    }

    return Post(
      uid: jsonMap["uid"],
      userId: jsonMap["userId"],
      text: jsonMap["text"],
      fileList: fileList,
      createdAt: jsonMap["createdAt"],
      updatedAt: jsonMap["updatedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'text': text,
        'fileList': fileList,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
