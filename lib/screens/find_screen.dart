import 'package:flutter/material.dart';
import 'package:lynou/components/search_bar.dart';
import 'package:lynou/localization/app_translations.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class FindScreen extends StatefulWidget {
  @override
  _FindScreenState createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {
  ThemeProvider _themeProvider;

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTranslations.of(context).text("search_title"),
        ),
        backgroundColor: _themeProvider.backgroundColor,
        elevation: 0,
        brightness: _themeProvider.setBrightness(),
        centerTitle: true,
      ),
      body: Container(
        color: _themeProvider.backgroundColor,
        child: Column(
          children: <Widget>[
            SearchBar(),
          ],
        ),
      ),
    );
  }
}
