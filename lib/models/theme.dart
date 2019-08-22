import 'package:flutter/material.dart';

class LYTheme {
  final int id;
  final Color backgroundColor;
  final Color firstColor;
  final Color secondColor;
  final Color textColor;
  final Color secondTextColor;
  final bool isLight;

  LYTheme({
    @required this.id,
    @required this.backgroundColor,
    @required this.firstColor,
    @required this.secondColor,
    @required this.textColor,
    @required this.secondTextColor,
    @required this.isLight,
  });
}
