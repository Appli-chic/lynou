import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class LYChip extends StatelessWidget {
  final String text;

  LYChip({
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: true);

    return Chip(
      label: Text("Family"),
      labelStyle: TextStyle(color: themeProvider.secondColor, fontSize: 14),
      backgroundColor: themeProvider.secondBackgroundColor,
      labelPadding: EdgeInsets.only(left: 6, right: 6),
    );
  }
}
