import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class LYChip extends StatefulWidget {
  final String text;

  LYChip({
    this.text,
  });

  @override
  _LYChipState createState() => _LYChipState();
}

class _LYChipState extends State<LYChip> {
  GlobalKey _textKey = GlobalKey();
  RenderBox _textRenderBox;
  ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    // this will be called after first draw, and then call _recordSize() method
    WidgetsBinding.instance.addPostFrameCallback((_) => _recordSize());
  }

  void _recordSize() {
    // now we set the RenderBox and trigger a redraw
    setState(() {
      _textRenderBox = _textKey.currentContext.findRenderObject();
    });
  }

  Shader getTextGradient(RenderBox renderBox) {
    if (renderBox == null) return null;
    return LinearGradient(
      colors: <Color>[_themeProvider.firstColor, _themeProvider.secondColor],
    ).createShader(
      Rect.fromLTWH(
          renderBox.localToGlobal(Offset.zero).dx,
          renderBox.localToGlobal(Offset.zero).dy,
          renderBox.size.width,
          renderBox.size.height),
    );
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
      decoration: BoxDecoration(
          color: _themeProvider.secondBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        "Family",
        key: _textKey,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          foreground: Paint()..shader = getTextGradient(_textRenderBox),
        ),
      ),
    );
  }
}
