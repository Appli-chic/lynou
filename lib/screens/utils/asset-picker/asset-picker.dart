import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:lynou/screens/utils/asset-picker/gallery_widget.dart';
import 'package:lynou/screens/utils/asset-picker/multi_selector_model.dart';
import 'package:media_picker_builder/data/album.dart';
import 'package:media_picker_builder/data/media_file.dart';
import 'package:media_picker_builder/media_picker_builder.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AssetPicker extends StatefulWidget {
  final bool withImages;
  final bool withVideos;
  final Function(Set<MediaFile> selectedFiles) onDone;
  final Function() onCancel;

  AssetPicker({
    @required this.withImages,
    @required this.withVideos,
    @required this.onDone,
    @required this.onCancel,
  });

  static Future<bool> checkPermission() async {
    final permissionStorageGroup =
        Platform.isIOS ? PermissionGroup.photos : PermissionGroup.storage;
    Map<PermissionGroup, PermissionStatus> res =
        await PermissionHandler().requestPermissions([
      permissionStorageGroup,
    ]);
    return res[permissionStorageGroup] == PermissionStatus.granted;
  }

  @override
  State<StatefulWidget> createState() => _AssetPickerState();
}

class _AssetPickerState extends State<AssetPicker> {
  List<Album> _albums;
  Album _selectedAlbum;
  bool _loading = true;
  MultiSelectorModel _selector = MultiSelectorModel();
  ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    MediaPickerBuilder.getAlbums(
      withImages: widget.withImages,
      withVideos: widget.withVideos,
    ).then((albums) {
      setState(() {
        _loading = false;
        _albums = albums;
        if (albums.isNotEmpty) {
          albums.sort((a, b) => b.files.length.compareTo(a.files.length));
          _selectedAlbum = albums[0];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return _loading
        ? Center(child: CircularProgressIndicator())
        : _buildWidget();
  }

  _buildWidget() {
    if (_albums.isEmpty)
      return Center(child: Text("You have no folders to select from"));

    final dropDownAlbumsWidget = Theme(
      data: Theme.of(context).copyWith(
        canvasColor: _themeProvider.backgroundColor
      ),
      child: DropdownButton<Album>(
        value: _selectedAlbum,
        onChanged: (Album newValue) {
          setState(() {
            _selectedAlbum = newValue;
          });
        },
        items: _albums.map<DropdownMenuItem<Album>>((Album album) {
          return DropdownMenuItem<Album>(
            value: album,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 150),
              child: Text(
                "${album.name} (${album.files.length})",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: _themeProvider.textColor),
              ),
            ),
          );
        }).toList(),
      ),
    );

    return ChangeNotifierProvider<MultiSelectorModel>(
      builder: (context) => _selector,
      child: Container(
        height: double.infinity,
        color: _themeProvider.backgroundColor,
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 60,
                  child: FlatButton(
                    padding: EdgeInsets.only(left: 8),
                    textColor: Colors.white,
                    onPressed: () => widget.onCancel(),
                    child: Text("Cancel"),
                  ),
                ),
                dropDownAlbumsWidget,
                Consumer<MultiSelectorModel>(
                  builder: (context, selector, child) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 70),
                      child: FlatButton(
                        padding: EdgeInsets.only(right: 8),
                        textColor: _themeProvider.firstColor,
                        onPressed: () => widget.onDone(_selector.selectedItems),
                        child: Text(
                          "Done (${selector.selectedItems.length})",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            GalleryWidget(mediaFiles: _selectedAlbum.files),
          ],
        ),
      ),
    );
  }
}
