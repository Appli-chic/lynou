import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lynou/models/post.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Create a post directly in firebase
  ///
  /// It sends the written [text] and is assigned to the user with the user's id
  Future<void> createPost(String text) async {
    var user = await _auth.currentUser();

    var post = Post(
      userId: user.uid,
      text: text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await Firestore.instance
        .collection('posts')
        .document()
        .setData(post.toJson());
  }
}