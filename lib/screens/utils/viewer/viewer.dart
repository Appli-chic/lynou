import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lynou/screens/utils/viewer/photo_view_gallery.dart';
import 'package:lynou/screens/utils/viewer/src/photo_view_computed_scale.dart';
import 'package:media_picker_builder/data/media_file.dart';

class Viewer extends StatefulWidget {
  final List<MediaFile> files;
  final List<String> firebaseUrlList;
  final int index;

  Viewer({
    this.files,
    this.firebaseUrlList,
    this.index,
  });

  @override
  _ViewerState createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.index);
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  dispose(){
    _pageController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Display assets from actual files
    if(widget.files != null) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                // Displays images
                if(widget.files[index].type == MediaType.IMAGE) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: Image.file(File(widget.files[index].path)).image,
                    initialScale: PhotoViewComputedScale.contained,
                    heroTag: widget.files.indexOf(widget.files[index]),
                  );
                } else {
                  return PhotoViewGalleryPageOptions(
                    videoUrl: widget.files[index].path,
                    initialScale: PhotoViewComputedScale.contained,
                    heroTag: widget.files.indexOf(widget.files[index]),
                  );
                }
              },
              itemCount: widget.files.length,
              pageController: _pageController,
            ),
            ConstrainedBox(
              constraints: BoxConstraints.loose(Size(double.infinity, kToolbarHeight)),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          ],
        ),
      );
    }

    // Display assets from firebase images
    if(widget.firebaseUrlList != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  firebaseUrl: widget.firebaseUrlList[index],
                  initialScale: PhotoViewComputedScale.contained,
                  heroTag: widget.firebaseUrlList.indexOf(widget.firebaseUrlList[index]),
                );
              },
              itemCount: widget.firebaseUrlList.length,
              pageController: _pageController,
            ),
          ],
        ),
      );
    }

    return Container();
  }
}
