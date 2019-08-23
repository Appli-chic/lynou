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

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    final timeFormatted = timeago.format(
      widget.post.createdAt.toDate(),
      locale: AppTranslations.of(context).locale.languageCode,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LYAvatar(size: 57),
            Expanded(
              child: Column(
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
                              fontWeight: FontWeight.bold,
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
          ],
        ),
        Text(
          widget.post.text,
          maxLines: 6,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _themeProvider.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              child: GestureDetector(
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
              child: GestureDetector(
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
