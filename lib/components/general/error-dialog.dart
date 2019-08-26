import 'package:flutter/material.dart';
import 'package:lynou/localization/app_translations.dart';
import 'package:lynou/providers/theme_provider.dart';

class ErrorDialog {
  final BuildContext context;
  final ThemeProvider themeProvider;
  final String title;
  final String description;

  ErrorDialog({
    @required this.context,
    @required this.themeProvider,
    this.title,
    @required this.description,
  });

  show() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: themeProvider.backgroundColor,
          title: Text(
            title != null ? title : AppTranslations.of(context).text("error_dialog"),
            style: TextStyle(color: themeProvider.textColor),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  description,
                  style: TextStyle(color: themeProvider.textColor),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                AppTranslations.of(context).text("ok"),
                style: TextStyle(color: themeProvider.firstColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
