import 'package:flutter/material.dart';
import 'package:lynou/components/forms/rounded_button.dart';
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
  TextEditingController _textController = TextEditingController();
  ThemeProvider _themeProvider;
  UserService _userService;

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _userService = Provider.of<UserService>(context);

    /// Send the post to FireBase and upload files
    _sendPost() {
      if (_textController.text != null && _textController.text.isNotEmpty) {
        _userService.createPost(_textController.text);
      }
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
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(16),
                    child: LYAvatar(),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 16, right: 16),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              AppTranslations.of(context).text("new_post_hint"),
                          hintStyle:
                              TextStyle(color: _themeProvider.secondTextColor),
                        ),
                        style: TextStyle(color: _themeProvider.textColor),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt,
                      color: _themeProvider.textColor,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.photo_library,
                      color: _themeProvider.textColor,
                      size: 30,
                    ),
                  ),
                  Spacer(),
                  RoundedButton(
                    onClick: _sendPost,
                    text: AppTranslations.of(context).text("send"),
                    width: 80,
                    height: 40,
                    textSize: 15,
                    cornerRadius: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
