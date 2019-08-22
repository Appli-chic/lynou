import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:lynou/models/post.dart';
import 'package:lynou/models/user.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get the user by it's [userId] from the cache of Firestore
  /// If the user doesn't exists then we retrieve it from the server
  Future<User> getUserFromCacheIfExists(String userId) async {
    User user;

    try {
      var document = await Firestore.instance
          .collection('users')
          .document(userId)
          .get(source: Source.cache);

      user = User.fromJson(document.data);
    } catch (e) {
      if (e is PlatformException && e.code == "Error 14") {
        // Can't find the user in the cache. We need to ask the server
        var document = await Firestore.instance
            .collection('users')
            .document(userId)
            .get(source: Source.server);

        user = User.fromJson(document.data);
      }
    }

    return user;
  }

  /// Create a post directly in firebase
  ///
  /// It sends the written [text] and is assigned to the user with the user's id
  Future<Post> createPost(String text) async {
    var user = await _auth.currentUser();

    var post = Post(
      userId: user.uid,
      text: text,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );

    await Firestore.instance
        .collection('posts')
        .document()
        .setData(post.toJson());

    return post;
  }

  /// Fetch all the posts concerning the user and his friends
  Future<List<Post>> fetchWallPosts() async {
    var user = await _auth.currentUser();
    var postList = List<Post>();
    var query = await Firestore.instance
        .collection('posts')
        .where('userId', isEqualTo: user.uid)
        .getDocuments();

    for(var document in query.documents) {
      var post = Post.fromJson(document.data);
      var user = await getUserFromCacheIfExists(document.data['userId']);

      post.name = user.name;
      postList.add(post);
    }

    return postList;
  }
}
