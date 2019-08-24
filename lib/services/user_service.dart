import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lynou/models/file.dart';
import 'package:path/path.dart';
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
      var document = await Firestore.instance
          .collection('users')
          .document(userId)
          .get(source: Source.server);

      user = User.fromJson(document.data);
    }

    return user;
  }

  /// Create a post directly in firebase
  ///
  /// It sends the written [text] and is assigned to the user with the user's id
  /// If the the post also contains [files] to upload
  Future<Post> createPost(String text, List<File> files) async {
    var user = await _auth.currentUser();
    var postId = Firestore.instance.collection('posts').document().documentID;

    // Upload files if they exist
    for (var file in files) {
      String path = 'users/${user.uid}/posts/${basename(file.path)}';
      final StorageReference storageReference =
          FirebaseStorage().ref().child(path);
      StorageUploadTask uploadTask = storageReference.putFile(file);
      await uploadTask.onComplete;

      // Add the file in the database
      LYFile lyFile = LYFile(
        userId: user.uid,
        postId: postId,
        path: path,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      await Firestore.instance
          .collection('files')
          .document()
          .setData(lyFile.toJson());
    }

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
        .orderBy('updatedAt', descending: true)
        .getDocuments();

    for (var document in query.documents) {
      var post = Post.fromJson(document.data);
      var user = await getUserFromCacheIfExists(document.data['userId']);

      post.name = user.name;
      postList.add(post);
    }

    return postList;
  }
}
