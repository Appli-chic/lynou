import 'package:flutter/material.dart';
import 'package:lynou/localization/app_translations.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ThemeProvider _themeProvider;

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.of(context).text("home_title")),
        backgroundColor: _themeProvider.backgroundColor,
        elevation: 0,
        brightness: _themeProvider.setBrightness(),
      ),
      body: Container(
        color: _themeProvider.backgroundColor,
      ),
    );
  }
}
