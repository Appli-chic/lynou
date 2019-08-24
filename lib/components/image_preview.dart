import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  final File file;
  final int index;
  final Function(File) onTap;
  final Function(File) onRemove;

  ImagePreview({
    @required this.file,
    @required this.onTap,
    @required this.index,
    @required this.onRemove,
  });

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
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
//            fit: StackFit.expand,
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
              Align(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
