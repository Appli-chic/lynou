import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lynou/components/forms/loading_dialog.dart';
import 'package:lynou/components/forms/rounded_button.dart';
import 'package:lynou/components/general/avatar.dart';
import 'package:lynou/components/general/error-dialog.dart';
import 'package:lynou/components/image_preview.dart';
import 'package:lynou/localization/app_translations.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:lynou/screens/utils/asset-picker/asset-picker.dart';
import 'package:lynou/screens/utils/viewer/viewer.dart';
import 'package:lynou/services/user_service.dart';
import 'package:lynou/utils/compressor.dart';
import 'package:media_picker_builder/data/media_file.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final navigatorKey = GlobalKey<NavigatorState>();
  TextEditingController _textController = TextEditingController();
  ThemeProvider _themeProvider;
  UserService _userService;

  List<MediaFile> _fileList = List();
  bool _isLoading = false;

  /// Call the camera and retrieve the photo taken
  /// Ask the permission to access the camera if it not granted yet.
  Future _getImageFromCamera() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      image = await Compressor.compressFile(image);

      _fileList.add(
          MediaFile(id: Uuid().v1(), path: image.path, type: MediaType.IMAGE));
      setState(() {});
    }
  }

  /// Call the Gallery and retrieve the photos
  Future _getImageFromGallery() async {
    var isGranted = await AssetPicker.checkPermission();
    var appTranslations = AppTranslations.of(context);

    if (isGranted) {
      await showModalBottomSheet<Set<MediaFile>>(
        context: navigatorKey.currentState.overlay.context,
        builder: (BuildContext context) {
          return AssetPicker(
            appTranslations: appTranslations,
            withImages: true,
            withVideos: true,
            onDone: (Set<MediaFile> selectedFiles) async {
              for (var asset in selectedFiles.toList()) {
                if (asset.type == MediaType.IMAGE) {
                  var image = await Compressor.compressFile(File(asset.path));
                  _fileList.add(
                    MediaFile(
                      id: Uuid().v1(),
                      path: image.path,
                      type: MediaType.IMAGE,
                    ),
                  );
                } else {
                  _fileList.add(asset);
                }
              }

              setState(() {});
              Navigator.pop(context);
            },
            onCancel: () {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  /// Send the post to FireBase and upload files
  _sendPost() async {
    if ((_textController.text != null && _textController.text.isNotEmpty) ||
        _fileList.isNotEmpty) {
      // Send the post
      this.setState(() {
        _isLoading = true;
      });

      var user = await FirebaseAuth.instance.currentUser();
      var post = await _userService.createPost(_textController.text, _fileList);
      var newUser = await _userService.getUserFromCacheIfExists(user.uid);
      post.name = newUser.name;

      this.setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop(post);
    } else {
      // Show error message
      var errorDialog = ErrorDialog(
        context: context,
        themeProvider: _themeProvider,
        description: AppTranslations.of(context).text("new_post_error_empty"),
      );
      errorDialog.show();
    }
  }

  /// Generates preview photos for the selected medias to send.
  List<Widget> _generatesPreviews() {
    List<Widget> result = [];

    _fileList.asMap().forEach((index, file) {
      result.add(
        ImagePreview(
          file: file,
          index: index,
          onTap: _onFileClicked,
          onRemove: _onFileRemoved,
        ),
      );
    });

    return result;
  }

  /// Displays the bottom bar containing the actions:
  /// - Taking a photo
  /// - Selecting photos from the gallery
  /// - Send the post
  Widget _displaysBottomBar() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: _getImageFromCamera,
            icon: Icon(
              Icons.camera_alt,
              color: _themeProvider.textColor,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: _getImageFromGallery,
            icon: Icon(
              Icons.photo_library,
              color: _themeProvider.textColor,
              size: 30,
            ),
          ),
          Spacer(),
          RoundedButton(
            onClick: _sendPost,
            text: AppTranslations.of(context).text("send"),
            width: 80,
            height: 40,
            textSize: 15,
            cornerRadius: 10,
          ),
        ],
      ),
    );
  }

  /// Show the preview of the file into a new page.
  /// Only supports images.
  _onFileClicked(MediaFile file) async {
    int index = _fileList.indexOf(file);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Viewer(
          files: _fileList,
          index: index,
        ),
      ),
    );
  }

  /// Triggers when the user click to remove the file from the list.
  /// This function removes the file from the list and rebuild.
  _onFileRemoved(MediaFile file) {
    int index = _fileList.indexOf(file);
    _fileList.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _userService = Provider.of<UserService>(context);

    return LoadingDialog(
      isDisplayed: _isLoading,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              AppTranslations.of(context).text("new_post_title"),
            ),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(null),
            ),
            centerTitle: true,
            backgroundColor: _themeProvider.backgroundColor,
            elevation: 0,
            brightness: _themeProvider.setBrightness(),
          ),
          body: Container(
            color: _themeProvider.backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(16),
                        child: LYAvatar(),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 8, right: 16),
                          child: TextField(
                            controller: _textController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppTranslations.of(context)
                                  .text("new_post_hint"),
                              hintStyle: TextStyle(
                                  color: _themeProvider.secondTextColor),
                            ),
                            style: TextStyle(color: _themeProvider.textColor),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8, right: 16, left: 16),
                  height: 150,
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: _generatesPreviews(),
                  ),
                ),
                _displaysBottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
