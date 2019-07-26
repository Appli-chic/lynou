import 'package:flutter/material.dart';
import 'package:lynou/utils/constants.dart';

class RoundedButton extends StatefulWidget {
  final String text;
  final Function onClick;

  RoundedButton({
    @required this.text,
    this.onClick,
  });

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          widget.onClick();
        },
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                RED_FIRST_COLOR,
                RED_SECOND_COLOR,
              ],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(28)),
          ),
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 18,
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
