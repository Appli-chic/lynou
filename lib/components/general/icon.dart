import 'package:flutter/material.dart';
import 'package:lynou/models/theme.dart';

class LYIcon extends StatelessWidget {
  final LYTheme theme;
  final IconData iconData;
  final Color color;
  final double size;

  static const double LARGE_SIZE = 30;
  static const double MEDIUM_SIZE = 25;
  static const double SMALL_SIZE = 20;

  LYIcon({
    this.theme,
    @required this.iconData,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    double _size = MEDIUM_SIZE;

    if (size != null) {
      _size = size;
    }

    if (color != null) {
      return Icon(iconData, color: color, size: _size);
    } else {
      return ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            colors: <Color>[
              theme.firstColor,
              theme.secondColor,
            ],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        child: Icon(
          iconData,
          size: _size,
        ),
      );
    }
  }
}
