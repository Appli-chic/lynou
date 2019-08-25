import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  final File file;
  final int index;
  final Function(File) onTap;
  final Function(File) onRemove;
  final bool isRemovable;

  ImagePreview({
    @required this.file,
    @required this.onTap,
    this.index,
    this.onRemove,
    this.isRemovable,
  });

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  Widget _displaysDeleteIcon() {
    if (widget.isRemovable) {
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
                    widget.file,
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
