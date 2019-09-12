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
import 'package:uuid/uuid.dart';

const String FILE_DOWNLOAD = "/api/file";
const String FILE_DOWNLOAD_VIDEO = "/api/video";
const String FILE_UPLOAD = "/api/file";

class StorageService {
  final Env env;

  StorageService({
    this.env,
  });

  /// Retrieve the download url from the [name] of a video
  Future<String> getFileVideoDownloadUrl(String name) async {
    final storage = FlutterSecureStorage();
    var accessToken = await storage.read(key: env.accessTokenKey);
    return "${env.apiUrl}$FILE_DOWNLOAD_VIDEO/$name?key=$accessToken";
  }

  /// Retrieve the download url from the [name] of a file
  String getFileDownloadUrl(String name) {
    return "${env.apiUrl}$FILE_DOWNLOAD/$name";
  }

  /// Upload a [file] to the server, if [isUploadingThumbnail] is true then
  /// we will upload the thumbnail data.
  /// Return the new name of the file uploaded
  Future<String> uploadFile(MediaFile file, bool isUploadingThumbnail) async {
    final storage = FlutterSecureStorage();
    var accessToken = await storage.read(key: env.accessTokenKey);
    String name = Uuid().v1();

    // Create the request
    var request;

    if (!isUploadingThumbnail) {
      name += path.extension(file.path);
      request = http.MultipartRequest(
          "POST", Uri.parse("${env.apiUrl}$FILE_UPLOAD/$name"));
    } else {
      name += path.extension(file.thumbnailPath);
      request = http.MultipartRequest(
          "POST", Uri.parse("${env.apiUrl}$FILE_UPLOAD/$name"));
    }

    request.headers
        .addAll({HttpHeaders.authorizationHeader: "Bearer $accessToken"});

    // Add Data
    if (!isUploadingThumbnail) {
      // Upload an image or a video
      String mimeType = mime(file.path.toLowerCase());
      var mimTypesSplit = mimeType.split("/");

      var fileData = await http.MultipartFile.fromPath('file', file.path,
          contentType: parser.MediaType(mimTypesSplit[0], mimTypesSplit[1]));
      request.files.add(fileData);
    } else {
      // Upload the thumbnail of a video
      String mimeType = mime(file.thumbnailPath.toLowerCase());
      var mimTypesSplit = mimeType.split("/");

      var fileData = await http.MultipartFile.fromPath(
          'file', file.thumbnailPath,
          contentType: parser.MediaType(mimTypesSplit[0], mimTypesSplit[1]));
      request.files.add(fileData);
    }

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      // Retrieve the new file name
      return name;
    } else {
      throw ApiError();
    }
  }
}
