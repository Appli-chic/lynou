import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Viewer extends StatefulWidget {
  final List<File> files;
  final int index;

  Viewer({
    this.files,
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: Image.file(widget.files[index]).image,
            initialScale: PhotoViewComputedScale.contained,
            heroTag: widget.files.indexOf(widget.files[index]),
          );
        },
        itemCount: widget.files.length,
        pageController: _pageController,
      ),
    );
  }
}
