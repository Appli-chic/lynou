import 'dart:io';

import 'package:media_picker_builder/data/media_file.dart';
import 'package:path/path.dart';
import 'package:lynou/models/database/post.dart';
import 'package:lynou/models/database/user.dart';

class UserService {

  /// Get the user by it's [userId] from the cache of Firestore
  /// If the user doesn't exists then we retrieve it from the server
  Future<User> getUserFromCacheIfExists(String userId) async {
    User user;

//    try {
//      var document = await Firestore.instance
//          .collection('users')
//          .document(userId)
//          .get(source: Source.cache);
//
//      user = User.fromJson(document.data);
//    } catch (e) {
//      var document = await Firestore.instance
//          .collection('users')
//          .document(userId)
//          .get(source: Source.server);
//
//      user = User.fromJson(document.data);
//    }

    return user;
  }

  /// Create a post directly in firebase
  ///
  /// It sends the written [text] and is assigned to the user with the user's id
  /// If the the post also contains [files] to upload
  Future<Post> createPost(String text, List<MediaFile> files) async {
//    var user = await _auth.currentUser();
//    var postId = Firestore.instance.collection('posts').document().documentID;
//    List<String> fileList = [];
//
//    // Upload files if they exist
//    for (var file in files) {
//      String path = 'users/${user.uid}/posts/$postId/${basename(file.path)}';
//      final StorageReference storageReference =
//          FirebaseStorage().ref().child(path);
//
//      StorageUploadTask uploadTask = storageReference.putFile(File(file.path));
//      await uploadTask.onComplete;
//
//      // Upload thumbnails
//      if (file.type == MediaType.VIDEO) {
//        var fileName = basenameWithoutExtension(file.path) + ".jpg";
//        String path = 'users/${user.uid}/posts/$postId/$fileName';
//        final StorageReference thumbnailStorageReference =
//            FirebaseStorage().ref().child(path);
//        StorageUploadTask thumbnailUploadTask =
//            thumbnailStorageReference.putFile(File(file.thumbnailPath));
//        await thumbnailUploadTask.onComplete;
//      }
//
//      fileList.add(basename(file.path));
//    }
//
//    var post = Post(
//      userId: user.uid,
//      text: text,
//      fileList: fileList,
//      createdAt: Timestamp.now(),
//      updatedAt: Timestamp.now(),
//    );
//
//    await Firestore.instance
//        .collection('posts')
//        .document(postId)
//        .setData(post.toJson());
//
//    post.uid = postId;
//    return post;
  }

  /// Fetch all the posts concerning the user and his friends
  /// Add a last UID to retrieve only after a specific document.
//  Future<List<Post>> fetchWallPosts(Source source, {DocumentSnapshot document}) async {
//    var user = await _auth.currentUser();
//    var postList = List<Post>();
//    var query;
//
//    if(document == null) {
//      query = await Firestore.instance
//          .collection('posts')
//          .where('userId', isEqualTo: user.uid)
//          .limit(10)
//          .orderBy('updatedAt', descending: true)
//          .getDocuments(source: source);
//    } else {
//      query = await Firestore.instance
//          .collection('posts')
//          .where('userId', isEqualTo: user.uid)
//          .limit(10)
//          .orderBy('updatedAt', descending: true)
//          .startAfterDocument(document)
//          .getDocuments(source: source);
//    }
//
//    for (var document in query.documents) {
//      var post = Post.fromJson(document.data);
//      var user = await getUserFromCacheIfExists(document.data['userId']);
//
//      post.name = user.name;
//      post.uid = document.documentID;
//      postList.add(post);
//    }
//
//    return postList;
//  }

  /// Retrieve the offline document from a post.
//  Future<DocumentSnapshot> fetchPostOfflineDocumentByUid(String uid) async {
//    var query = await Firestore.instance
//        .collection('posts')
//        .where(uid)
//        .getDocuments(source: Source.cache);
//
//    if(query.documents.isEmpty) {
//      throw Exception;
//    }
//
//    return query.documents[0];
//  }
}
