import 'package:flutter/material.dart';
import 'package:lynou/components/general/avatar.dart';
import 'package:lynou/components/general/cached_image.dart';
import 'package:lynou/components/general/chip.dart';
import 'package:lynou/localization/app_translations.dart';
import 'package:lynou/models/database/file.dart';
import 'package:lynou/models/database/post.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:lynou/screens/utils/viewer/viewer.dart';
import 'package:lynou/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFeed extends StatefulWidget {
  final Post post;

  PostFeed({
    this.post,
  });

  @override
  _PostFeedState createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed>
    with AutomaticKeepAliveClientMixin {
  ThemeProvider _themeProvider;
  StorageService _storageService;

  /// Displays photos an videos linked to the post
  /// Videos are displayed with a thumbnail image and a video logo
  ///
  /// If there is only one media, we display it on the whole width
  /// If there is more than one media we display them in a grid
  ///
  /// The maximum of medias displayed is 8
  /// When more than 8 are displayed we show a + in the last media.
  Widget _displaysMedia() {
    // Displays only one media
    if (widget.post.fileList != null && widget.post.fileList.length == 1) {
      var file = widget.post.fileList[0];

      String url;
      if (file.type == TYPE_VIDEO) {
        url = _storageService.getFileDownloadUrl(file.thumbnail);
      } else {
        url = _storageService.getFileDownloadUrl(file.name);
      }


      return GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Viewer(
                lynouFiles: widget.post.fileList,
                index: 0,
              ),
            ),
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 8),
              child: CachedImage(
                url: url,
                heightPlaceholder: 200,
                width: double.infinity,
              ),
            ),
            widget.post.fileList[0].type == TYPE_VIDEO
                ? Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Center(
                      child: Icon(
                        Icons.play_circle_filled,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    } else if (widget.post.fileList != null &&
        widget.post.fileList.length > 1) {
      // Displays more than one media
      List<Widget> listAssets = [];

      int crossAxisCount = 4;
      if (widget.post.fileList.length < 4) {
        crossAxisCount = widget.post.fileList.length;
      }

      for (var file in widget.post.fileList) {
        int index = widget.post.fileList.indexOf(file);

        if (index < 4) {
          listAssets.add(
            _displayAssetForGrid(index, file),
          );
        }
      }

      return Container(
        color: _themeProvider.secondBackgroundColor,
        margin: EdgeInsets.only(top: 8),
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          shrinkWrap: true,
          children: listAssets,
        ),
      );
    }

    return Container();
  }

  /// Displays photos and videos for the grid in case of a post with many
  /// images or videos.
  Widget _displayAssetForGrid(int index, LYFile file) {
    String url;

    if (file.type == TYPE_VIDEO) {
      url = _storageService.getFileDownloadUrl(file.thumbnail);
    } else {
      url = _storageService.getFileDownloadUrl(file.name);
    }

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Viewer(
              lynouFiles: widget.post.fileList,
              index: index,
            ),
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          CachedImage(
            url: url,
            boxFit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            heightPlaceholder: double.infinity,
            widthPlaceholder: double.infinity,
          ),
          file.type == TYPE_VIDEO
              ? Center(
                  child: Icon(
                    Icons.play_circle_filled,
                    color: Colors.white,
                    size: 40,
                  ),
                )
              : Container(),
          index == 3 && widget.post.fileList.length != 4
              ? Container(
                  color: Colors.black54,
                  child: Center(
                    child: Text(
                      '+${widget.post.fileList.length - 4}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _storageService = Provider.of<StorageService>(context);

    var languageCode =
        AppTranslations.of(context).locale.languageCode.split("_")[0] +
            "_short";
    final timeFormatted = timeago.format(
      widget.post.createdAt,
      locale: languageCode,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LYAvatar(size: 50),
            Expanded(
              child: Container(
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              widget.post.user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _themeProvider.textColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          timeFormatted,
                          style: TextStyle(
                            color: _themeProvider.textColor,
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: LYChip(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            widget.post.text,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _themeProvider.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        _displaysMedia(),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () {},
                child: Icon(
                  Icons.favorite,
                  color: _themeProvider.textColor,
                  size: 20,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 24),
              child: InkWell(
                onTap: () {},
                child: Icon(
                  Icons.comment,
                  color: _themeProvider.textColor,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
