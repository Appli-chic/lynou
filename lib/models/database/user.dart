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
      id: jsonMap["id"],
      email: jsonMap["email"],
      name: jsonMap["name"],
      photo: jsonMap["photo"],
      createdAt: jsonMap["created_at"],
      updatedAt: jsonMap["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
    'photo': photo,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}