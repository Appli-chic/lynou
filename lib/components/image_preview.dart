import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_picker_builder/data/media_file.dart';

class ImagePreview extends StatefulWidget {
  final MediaFile file;
  final int index;
  final Function(MediaFile) onTap;
  final Function(MediaFile) onRemove;

  ImagePreview({
    @required this.file,
    @required this.onTap,
    this.index,
    this.onRemove,
  });

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  Widget _displaysDeleteIcon() {
    if (widget.onRemove != null) {
      return Align(
        alignment: Alignment.topRight,
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(Size(20, 20)),
          child: GestureDetector(
            onTap: () {
              widget.onRemove(widget.file);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                color: Colors.black45,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.index,
      child: GestureDetector(
        onTap: () {
          widget.onTap(widget.file);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Container(
                  child: Image.file(
                    widget.file.type == MediaType.IMAGE ?
                    File(widget.file.path) : File(widget.file.thumbnailPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              _displaysDeleteIcon(),
            ],
          ),
        ),
      ),
    );
  }
}
