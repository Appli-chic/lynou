class Post {
  String uid;
  String userId;
  String text;
  DateTime createdAt;
  DateTime updatedAt;

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
