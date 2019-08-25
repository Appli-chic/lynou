import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:lynou/components/general/avatar.dart';
import 'package:lynou/components/general/chip.dart';
import 'package:lynou/localization/app_translations.dart';
import 'package:lynou/models/post.dart';
import 'package:lynou/providers/theme_provider.dart';
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

class _PostFeedState extends State<PostFeed> {
  ThemeProvider _themeProvider;

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
      return Container(
        margin: EdgeInsets.only(top: 8),
        child: CacheImage.firebase(
          fit: BoxFit.fitWidth,
          path:
              'users/${widget.post.userId}/posts/${widget.post.uid}/${widget.post.fileList[0]}',
          placeholder: Container(
            height: 150,
            color: _themeProvider.secondBackgroundColor,
          ),
        ),
      );
    } else if (widget.post.fileList != null &&
        widget.post.fileList.length > 1) {
      // Displays more than one media
      List<Widget> listAssets = [];

      final size = MediaQuery.of(context).size;

      for (var file in widget.post.fileList) {
        listAssets.add(
          CacheImage.firebase(
            fit: BoxFit.cover,
            width: (size.width - 32 / 4),
            height: 100,
            path: 'users/${widget.post.userId}/posts/${widget.post.uid}/$file',
            placeholder: Container(
              width: (size.width - 32 / 4),
              height: 100,
              color: _themeProvider.secondBackgroundColor,
            ),
          ),
        );
      }

      return Container(
        color: _themeProvider.secondBackgroundColor,
        margin: EdgeInsets.only(top: 8),
        child: GridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          shrinkWrap: true,
          children: listAssets,
        ),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    var languageCode =
        AppTranslations.of(context).locale.languageCode.split("_")[0] +
            "_short";
    final timeFormatted = timeago.format(
      widget.post.createdAt.toDate(),
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
                              widget.post.name,
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
}
