import 'package:flutter/material.dart';
import 'package:lynou/components/general/avatar.dart';
import 'package:lynou/localization/app_translations.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:lynou/services/user_service.dart';
import 'package:provider/provider.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  ThemeProvider _themeProvider;

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    /// Send the post to FireBase and upload files
    _sendPost() {
//      Navigator.of(context).pop(null);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTranslations.of(context).text("new_post_title"),
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              AppTranslations.of(context).text("new_post_publish"),
              style: TextStyle(color: _themeProvider.textColor),
            ),
            onPressed: _sendPost,
          ),
        ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(16),
                  child: LYAvatar(),
                ),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Text(
                    "What's new?",
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
