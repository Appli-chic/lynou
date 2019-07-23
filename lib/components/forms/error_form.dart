import 'package:flutter/material.dart';

class ErrorForm extends StatelessWidget {
  final List<String> errorList;

  ErrorForm({this.errorList});

  @override
  Widget build(BuildContext context) {
    List<Widget> _displayErrors() {
      List<Widget> _result = [];

      errorList.asMap().forEach((index, error) {
        Widget textWidget = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 6),
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  error,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );

        // Add padding if it's not the first item
        if (index == 0) {
          _result.add(textWidget);
        } else {
          _result.add(
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: textWidget,
            ),
          );
        }
      });

      return _result;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFCB2D3E),
            Color(0xFFEF473A),
          ],
        ),
        borderRadius: BorderRadius.all(
          const Radius.circular(8.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _displayErrors(),
      ),
    );
  }
}
