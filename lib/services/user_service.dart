import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lynou/models/api_error.dart';
import 'package:lynou/models/env.dart';
import 'package:lynou/services/storage_service.dart';
import 'package:media_picker_builder/data/media_file.dart';
import 'package:path/path.dart';
import 'package:lynou/models/database/post.dart';
import 'package:lynou/models/database/user.dart';
import 'package:http/http.dart' as http;

const String USER_GET_PHOTO = "/api/user/photo";

class UserService {
  var client = http.Client();
  final Env env;

  UserService({
    this.env,
  });

  // Fetch the url to
  Future<String> getProfilePhotoUrl() async {
    final storage = FlutterSecureStorage();
    var accessToken = await storage.read(key: env.accessTokenKey);

    var response = await client.get("${env.apiUrl}$USER_GET_PHOTO", headers: {
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    });

    if (response.statusCode == 200) {
      // Retrieve the user's photo url
      var photo = json.decode(response.body)["photo"];
      return "${env.apiUrl}$FILE_DOWNLOAD/$photo";
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }

  /// Get the user by it's [userId] from the cache of
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
