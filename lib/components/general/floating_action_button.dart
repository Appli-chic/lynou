import 'package:flutter/material.dart';
import 'package:lynou/models/theme.dart';

class LYFloatingActionButton extends StatelessWidget {
  final LYTheme theme;
  final IconData iconData;
  final Color color;
  final Function onClick;

  LYFloatingActionButton({
    this.theme,
    @required this.iconData,
    this.color,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              theme.firstColor,
              theme.secondColor,
            ],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(28)),
        ),
        child: FloatingActionButton(
          onPressed: onClick,
          child: Icon(iconData),
          backgroundColor: Colors.transparent,
          hoverElevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          elevation: 0,
        ),
      ),
    );
  }
}
