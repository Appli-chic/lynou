import 'package:flutter/material.dart';
import 'package:lynou/localization/app_translations.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  ThemeProvider _themeProvider;
  InputBorder _inputBorder = OutlineInputBorder();

  @override
  void initState() {
    _inputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      borderSide: BorderSide(color: Colors.transparent),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: TextField(
        textInputAction: TextInputAction.go,
        cursorColor: _themeProvider.firstColor,
        style: TextStyle(color: _themeProvider.textColor),
        decoration: InputDecoration(
          fillColor: _themeProvider.secondBackgroundColor,
          prefixIcon: Icon(Icons.search, color: _themeProvider.secondTextColor),
          border: _inputBorder,
          errorBorder: _inputBorder,
          focusedBorder: _inputBorder,
          filled: true,
          hintText: AppTranslations.of(context).text("search_hint"),
          contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 0),
          hintStyle: TextStyle(color: _themeProvider.secondTextColor),
        ),
      ),
    );
  }
}
