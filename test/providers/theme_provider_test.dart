import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynou/models/theme.dart';
import 'package:lynou/providers/theme_provider.dart';

void main() {
  testWidgets('Theme provider - Loading', (WidgetTester tester) async {
    final themeProvider = ThemeProvider();
    expect(themeProvider.backgroundColor, Color(0xF0212632));
    expect(themeProvider.firstColor, Color(0xFFCB2D3E));
    expect(themeProvider.secondColor, Color(0xFFEF473A));
    expect(themeProvider.textColor, Color(0xFFFFFFFF));

    var theme = LYTheme(
      id: DEFAULT_THEME_DARK,
      backgroundColor: Color(0xF0212632),
      firstColor: Color(0xFFCB2D3E),
      secondColor: Color(0xFFEF473A),
      textColor: Color(0xFFFFFFFF),
      isLight: false,
    );

    expect(theme.id, DEFAULT_THEME_DARK);
    expect(theme.backgroundColor, Color(0xF0212632));
    expect(theme.firstColor, Color(0xFFCB2D3E));
    expect(theme.secondColor, Color(0xFFEF473A));
    expect(theme.textColor, Color(0xFFFFFFFF));
  });

  testWidgets('Theme provider - Check the brigntess',
      (WidgetTester tester) async {
    final themeProvider = ThemeProvider();
    expect(themeProvider.setBrightness(), Brightness.dark);
  });

  testWidgets('Theme provider - Set theme', (WidgetTester tester) async {
    final themeProvider = ThemeProvider();
    themeProvider.setTheme(DEFAULT_THEME_LIGHT);

    var theme = themeProvider.theme;
    expect(theme.id, DEFAULT_THEME_LIGHT);
  });
}
