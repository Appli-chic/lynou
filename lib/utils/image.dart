import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as path;

class ImageUtils {
  static bool checkIfIsVideo(String firebaseUrl) {
    if(mime(path.basename(firebaseUrl)) == "video/mp4") {
      return true;
    } else {
      return false;
    }
  }


  /// Displays thumbnails if is a video
  static String displaysThumbnails(String firebaseUrl) {
    if(mime(path.basename(firebaseUrl)) == "video/mp4") {
      return path.setExtension(firebaseUrl, ".jpg");
    } else {
      return firebaseUrl;
    }
  }
}