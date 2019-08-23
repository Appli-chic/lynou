import 'package:flutter/material.dart';
import 'package:lynou/utils/constants.dart';

class RoundedButton extends StatefulWidget {
  final String text;
  final Function onClick;
  final double width;
  final double height;
  final double textSize;
  final double cornerRadius;

  RoundedButton({
    @required this.text,
    @required this.onClick,
    this.width,
    this.height,
    this.textSize,
    this.cornerRadius,
  });

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height != null ? widget.height : 48,
      child: FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          widget.onClick();
        },
        child: Container(
          width: widget.width != null ? widget.width : double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                RED_FIRST_COLOR,
                RED_SECOND_COLOR,
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(
                widget.cornerRadius != null ? widget.cornerRadius : 28)),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.textSize != null ? widget.textSize : 18,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
    );
  }
}
