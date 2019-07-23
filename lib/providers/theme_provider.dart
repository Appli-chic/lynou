import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lynou/models/lynou_theme.dart';
import 'package:lynou/utils/constants.dart';

const int DEFAULT_THEME_DARK = 0;
const int DEFAULT_THEME_LIGHT = 1;

class ThemeProvider with ChangeNotifier {
  List<LynouTheme> _themeList = List();
  LynouTheme _theme;

  ThemeProvider() {
    _generateThemeList();
    _loadTheme();
  }

  /// Generates the list of themes and insert it in the [_themeList].
  _generateThemeList() {
    LynouTheme _defaultDarkTheme = LynouTheme(
      id: DEFAULT_THEME_DARK,
      backgroundColor: Color(0xF0212632),
      firstColor: Color(0xFFCB2D3E),
      secondColor: Color(0xFFEF473A),
      textColor: Color(0xFFFFFFFF),
    );

    LynouTheme _defaultLightTheme = LynouTheme(
      id: DEFAULT_THEME_LIGHT,
      backgroundColor: Color(0xFFFFFFFF),
      firstColor: Color(0xFFCB2D3E),
      secondColor: Color(0xFFEF473A),
      textColor: Color(0xFF464646),
    );

    _themeList.add(_defaultDarkTheme);
    _themeList.add(_defaultLightTheme);
  }

  /// Load the [_theme] stored in the secured storage
  _loadTheme() async {
    final _storage = FlutterSecureStorage();
    String _themeString = await _storage.read(key: KEY_THEME);

    if (_themeString == null) {
      // If no theme setup yet, then we define the default dark theme.
      _theme = _themeList[0];
    } else {
      // Load the theme if it exists
      _theme = _themeList
          .where((theme) => theme.id == int.parse(_themeString))
          .toList()[0];
    }

    notifyListeners();
  }

  /// Set the new theme using the [id] of the [_theme]
  setTheme(int id) {
    _theme = _themeList.where((theme) => theme.id == id).toList()[0];
    notifyListeners();
  }

  /// Retrieve the background color corresponding to the [_theme]
  LynouTheme get getTheme => _theme;

  /// Retrieve the background color corresponding to the [_theme]
  Color get getBackgroundColor => _theme.backgroundColor;

  /// Retrieve the first color corresponding to the [_theme]
  Color get getFirstColor => _theme.firstColor;

  /// Retrieve the second color corresponding to the [_theme]
  Color get getSecondColor => _theme.secondColor;

  /// Retrieve the text color corresponding to the [_theme]
  Color get getTextColor => _theme.textColor;
}
