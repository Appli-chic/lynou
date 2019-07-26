import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynou/components/general/icon.dart';
import 'package:lynou/models/theme.dart';
import 'package:lynou/providers/theme_provider.dart';

void main() {
  testWidgets('LYIcon - Displays the icon with a color',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LYIcon(
          iconData: Icons.home,
          color: Colors.red,
        ),
      ),
    );

    var findByIcon = find.byIcon(Icons.home);
    expect(findByIcon.evaluate().isEmpty, false);
    expect(findByIcon.evaluate().length, 1);

    var icon = findByIcon.evaluate().toList()[0].widget as Icon;
    expect(icon.color, Colors.red);
    expect(icon.size, LYIcon.MEDIUM_SIZE);
  });

  testWidgets('LYIcon - Displays the icon with a color and a defined size',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LYIcon(
          iconData: Icons.home,
          color: Colors.red,
          size: LYIcon.LARGE_SIZE,
        ),
      ),
    );

    var findByIcon = find.byIcon(Icons.home);
    expect(findByIcon.evaluate().isEmpty, false);
    expect(findByIcon.evaluate().length, 1);

    var icon = findByIcon.evaluate().toList()[0].widget as Icon;
    expect(icon.color, Colors.red);
    expect(icon.size, LYIcon.LARGE_SIZE);
  });

  testWidgets('LYIcon - Displays the icon with a theme',
      (WidgetTester tester) async {
    LYTheme theme = LYTheme(
      id: DEFAULT_THEME_DARK,
      backgroundColor: Color(0xF0212632),
      firstColor: Color(0xFFCB2D3E),
      secondColor: Color(0xFFEF473A),
      textColor: Color(0xFFFFFFFF),
      isLight: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: LYIcon(
          iconData: Icons.home,
          theme: theme,
        ),
      ),
    );

    var findByIcon = find.byIcon(Icons.home);
    expect(findByIcon.evaluate().isEmpty, false);
    expect(findByIcon.evaluate().length, 1);

    var icon = findByIcon.evaluate().toList()[0].widget as Icon;
    expect(icon.size, LYIcon.MEDIUM_SIZE);

    var findByShaderMask = find.byType(ShaderMask);
    expect(findByShaderMask.evaluate().isEmpty, false);
  });
}
