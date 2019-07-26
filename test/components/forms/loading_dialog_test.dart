import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynou/components/forms/loading_dialog.dart';

void main() {
  testWidgets('LoadingDialog - Displays the loading dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoadingDialog(
          isDisplayed: true,
          child: Container(),
        ),
      ),
    );

    var findByCircularProgress = find.byType(CircularProgressIndicator);
    expect(findByCircularProgress.evaluate().isEmpty, false);
    expect(findByCircularProgress.evaluate().length, 1);
  });

  testWidgets('LoadingDialog - Doesn\'t display the loading dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoadingDialog(
          isDisplayed: false,
          child: Container(),
        ),
      ),
    );

    var findByCircularProgress = find.byType(CircularProgressIndicator);
    expect(findByCircularProgress.evaluate().isEmpty, true);
  });
}
