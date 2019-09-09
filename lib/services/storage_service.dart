import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lynou/models/api_error.dart';
import 'package:lynou/models/env.dart';
import 'package:media_picker_builder/data/media_file.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart' as parser;
import 'package:mime_type/mime_type.dart';

const String FILE_DOWNLOAD = "/api/file";
const String FILE_UPLOAD = "/api/file";

class StorageService {
  final Env env;

  StorageService({
    this.env,
  });

  /// Upload a file to the server
  Future<void> uploadFile(MediaFile file) async {
    final storage = FlutterSecureStorage();
    var accessToken = await storage.read(key: env.accessTokenKey);

    var request = http.MultipartRequest("POST",
        Uri.parse("${env.apiUrl}$FILE_UPLOAD/${path.basename(file.path)}"));
    request.headers
        .addAll({HttpHeaders.authorizationHeader: "Bearer $accessToken"});
    String mimeType = mime(file.path.toLowerCase());
    var fileData = await http.MultipartFile.fromPath('file', file.path,
        contentType: parser.MediaType('image', mimeType));
    request.files.add(fileData);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      // Retrieve the post
      return;
    } else {
      throw ApiError();
    }

//    request.headers = {HttpHeaders.authorizationHeader: "Bearer $accessToken"};
//    var response = await client.post(
//      "${env.apiUrl}$FILE_UPLOAD",
//      headers: {HttpHeaders.authorizationHeader: "Bearer $accessToken"},
//      body: json.encode({"text": text}),
//    );
  }
}
