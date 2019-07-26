import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lynou/models/theme.dart';
import 'package:lynou/utils/constants.dart';

const int DEFAULT_THEME_DARK = 0;
const int DEFAULT_THEME_LIGHT = 1;

class ThemeProvider with ChangeNotifier {
  List<LYTheme> _themeList = List();
  LYTheme _theme;

  ThemeProvider() {
    _generateThemeList();
    _theme = _themeList[0];
    _loadTheme();
  }

  /// Generates the list of themes and insert it in the [_themeList].
  _generateThemeList() {
    LYTheme _defaultDarkTheme = LYTheme(
      id: DEFAULT_THEME_DARK,
      backgroundColor: Color(0xF0212632),
      firstColor: Color(0xFFCB2D3E),
      secondColor: Color(0xFFEF473A),
      textColor: Color(0xFFFFFFFF),
      isLight: false,
    );

    LYTheme _defaultLightTheme = LYTheme(
      id: DEFAULT_THEME_LIGHT,
      backgroundColor: Color(0xFFFFFFFF),
      firstColor: Color(0xFFCB2D3E),
      secondColor: Color(0xFFEF473A),
      textColor: Color(0xFF464646),
      isLight: true,
    );

    _themeList.add(_defaultDarkTheme);
    _themeList.add(_defaultLightTheme);
  }

  /// Load the [_theme] stored in the secured storage
  _loadTheme() async {
    final _storage = FlutterSecureStorage();
    String _themeString = await _storage.read(key: KEY_THEME);

    if (_themeString != null) {
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

  /// Set the brightness from the actual [_theme]
  Brightness setBrightness() {
    if (theme.isLight) {
      return Brightness.light;
    } else {
      return Brightness.dark;
    }
  }

  /// Retrieve the background color corresponding to the [_theme]
  LYTheme get theme => _theme;

  /// Retrieve the background color corresponding to the [_theme]
  Color get backgroundColor => _theme.backgroundColor;

  /// Retrieve the first color corresponding to the [_theme]
  Color get firstColor => _theme.firstColor;

  /// Retrieve the second color corresponding to the [_theme]
  Color get secondColor => _theme.secondColor;

  /// Retrieve the text color corresponding to the [_theme]
  Color get textColor => _theme.textColor;
}
