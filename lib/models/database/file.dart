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
}