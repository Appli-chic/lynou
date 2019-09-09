import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lynou/models/api_error.dart';
import 'package:lynou/models/database/file.dart';
import 'package:lynou/models/database/post.dart';
import 'package:lynou/models/env.dart';
import 'package:lynou/services/storage_service.dart';
import 'package:media_picker_builder/data/media_file.dart';

const String POST_SAVE = "/api/post";
const String POST_GET_WALL = "/api/posts";

class PostService {
  var client = http.Client();
  final Env env;
  StorageService _storageService;

  PostService({
    this.env,
  }) {
    _storageService = StorageService(env: env);
  }

  /// Create a post
  ///
  /// It sends the written [text] and is assigned to the user with the user's id
  /// If the the post also contains [files] to upload
  Future<Post> createPost(String text, List<MediaFile> files) async {
    final storage = FlutterSecureStorage();
    var accessToken = await storage.read(key: env.accessTokenKey);

    // Upload all the files
    for(var file in files) {
      await _storageService.uploadFile(file);
    }

    // Create the posts
    var response = await client.post(
      "${env.apiUrl}$POST_SAVE",
      headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
      body: json.encode({"text": text}),
    );

    if (response.statusCode == 200) {
      // Retrieve the post
      return Post.fromJson(json.decode(response.body));
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }

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
  /// The page number indicates how many posts the user retrieved already
  Future<List<Post>> fetchWallPosts(int page) async {
    final storage = FlutterSecureStorage();
    var accessToken = await storage.read(key: env.accessTokenKey);

    var response = await client.get(
      "${env.apiUrl}$POST_GET_WALL?page=$page",
      headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
    );

    if (response.statusCode == 200) {
      // Retrieve the post
      List<dynamic> bodyList = json.decode(response.body)["posts"];
      List<Post> postList = [];
      for(var post in bodyList) {
        postList.add(Post.fromJson(post));
      }

      return postList;
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }

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
  }
}
