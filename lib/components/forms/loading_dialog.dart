import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final Widget child;
  final bool isDisplayed;

  LoadingDialog({@required this.child, @required this.isDisplayed});

  @override
  Widget build(BuildContext context) {
    if (isDisplayed) {
      return Stack(
        children: <Widget>[
          child,
          Opacity(
            child: Container(
              color: Colors.black,
              child: ModalBarrier(dismissible: false),
            ),
            opacity: 0.3,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              width: 100,
              height: 100,
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return child;
    }
  }
}
