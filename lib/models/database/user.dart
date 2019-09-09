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

  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
    'photo': photo,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}