import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lynou/models/api_error.dart';
import 'package:lynou/models/database/file.dart';
import 'package:lynou/models/database/post.dart';
import 'package:lynou/models/env.dart';
import 'package:lynou/providers/sqlite/file_provider.dart';
import 'package:lynou/providers/sqlite/post_provider.dart';
import 'package:lynou/providers/sqlite/user_provider.dart';
import 'package:lynou/services/storage_service.dart';
import 'package:lynou/utils/sqlite.dart';
import 'package:media_picker_builder/data/media_file.dart';
import 'package:path/path.dart' as path;

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
    List<Map<String, dynamic>> fileJsonList = [];
    final storage = FlutterSecureStorage();
    var accessToken = await storage.read(key: env.accessTokenKey);

    // Upload all the files
    for (var file in files) {
      if (file.type == MediaType.IMAGE) {
        file.path = await _storageService.uploadFile(file, false);
      } else if (file.type == MediaType.VIDEO) {
        file.path = await _storageService.uploadFile(file, false);
        file.thumbnailPath = await _storageService.uploadFile(file, true);
      }

      // Create files written json
      var newFile = LYFile(
        name: path.basename(file.path),
        thumbnail: file.thumbnailPath != null
            ? path.basename(file.thumbnailPath)
            : null,
        type: file.type == MediaType.IMAGE ? TYPE_IMAGE : TYPE_VIDEO,
      );

      fileJsonList.add(newFile.toJson());
    }

    // Create the posts
    var response = await client.post(
      "${env.apiUrl}$POST_SAVE",
      headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
      body: json.encode({"text": text, "files": fileJsonList}),
    );

    if (response.statusCode == 200) {
      // Retrieve the post
      return Post.fromJson(json.decode(response.body)["post"]);
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }

  /// Fetch all the posts concerning the user and his friends
  /// The page number indicates how many posts the user retrieved already
  Stream<List<Post>> fetchWallPosts(int page) async* {
    yield await PostProvider.fetchWallPosts(); // Return the data from sqlite

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
      for (var post in bodyList) {
        postList.add(Post.fromJson(post));
      }

      // Save data in sqlite
      for (var post in postList) {
        await PostProvider.save(post);
        await UserProvider.save(post.user);

        for (var file in post.fileList) {
          await FileProvider.save(file);
        }
      }

//      yield postList; // Return the data from the server
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }
}
