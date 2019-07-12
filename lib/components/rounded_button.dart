import 'package:flutter/material.dart';

class RoundedButton extends StatefulWidget {
  RoundedButton({
    this.text,
  });

  @override
  _RoundedButtonState createState() => _RoundedButtonState();

  final String text;
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () {},
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xFFCB2D3E),
                Color(0xFFEF473A),
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
