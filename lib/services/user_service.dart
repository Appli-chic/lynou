import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:media_picker_builder/data/media_file.dart';
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
  Future<Post> createPost(String text, List<MediaFile> files) async {
    var user = await _auth.currentUser();
    var postId = Firestore.instance.collection('posts').document().documentID;
    List<String> fileList = [];

    // Upload files if they exist
    for (var file in files) {
      String path = 'users/${user.uid}/posts/$postId/${basename(file.path)}';
      final StorageReference storageReference =
          FirebaseStorage().ref().child(path);

      if(file.type == MediaType.IMAGE) {
        StorageUploadTask uploadTask = storageReference.putFile(File(file.path));
        await uploadTask.onComplete;
      } else if(file.type == MediaType.VIDEO) {

      }

      fileList.add(basename(file.path));
    }

    var post = Post(
      userId: user.uid,
      text: text,
      fileList: fileList,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );

    await Firestore.instance
        .collection('posts')
        .document(postId)
        .setData(post.toJson());

    post.uid = postId;
    return post;
  }

  /// Fetch all the posts concerning the user and his friends
  Future<List<Post>> fetchWallPosts(Source source) async {
    var user = await _auth.currentUser();
    var postList = List<Post>();
    var query = await Firestore.instance
        .collection('posts')
        .where('userId', isEqualTo: user.uid)
        .orderBy('updatedAt', descending: true)
        .getDocuments(source: source);

    for (var document in query.documents) {
      var post = Post.fromJson(document.data);
      var user = await getUserFromCacheIfExists(document.data['userId']);

      post.name = user.name;
      post.uid = document.documentID;
      postList.add(post);
    }

    return postList;
  }
}
