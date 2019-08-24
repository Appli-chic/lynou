import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class Compressor {

  static Future<File> compressFile(File file) async {
    Directory dir = await path_provider.getTemporaryDirectory();
    String extension = path.extension(file.path);
    String name = Uuid().v1();
    String targetPath = dir.absolute.path + "/$name$extension";

    return await testCompressAndGetFile(file, targetPath);
  }

  static Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 88,
    );

    return result;
  }
}