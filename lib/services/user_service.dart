import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lynou/models/api_error.dart';
import 'package:lynou/models/env.dart';
import 'package:lynou/providers/sqlite/user_provider.dart';
import 'package:lynou/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:lynou/utils/token_parser.dart';

const String USER_GET_PHOTO = "/api/user/photo";

class UserService {
  var client = http.Client();
  final Env env;

  UserService({
    this.env,
  });

  // Fetch the url to
  Stream<String> getProfilePhotoUrl() async* {
    final storage = FlutterSecureStorage();
    var accessToken = await storage.read(key: env.accessTokenKey);
    var userId = TokenParser.getIdFromToken(accessToken);

    // Get the photo url from the sqlite
    var user = await UserProvider.findById(userId);
    yield "${env.apiUrl}$FILE_DOWNLOAD/${user.photo}";

    var response = await client.get("${env.apiUrl}$USER_GET_PHOTO", headers: {
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    });

    if (response.statusCode == 200) {
      // Retrieve the user's photo url
      var photo = json.decode(response.body)["photo"];
      yield "${env.apiUrl}$FILE_DOWNLOAD/$photo";
    } else {
      throw ApiError.fromJson(json.decode(response.body));
    }
  }
}
