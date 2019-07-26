import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynou/components/forms/rounded_button.dart';

void main() {
  testWidgets('RoundedButton - Displays button that says Hello',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RoundedButton(text: "Hello"),
      ),
    );

    var findByText = find.byType(Text);
    expect(findByText.evaluate().isEmpty, false);
    expect(findByText.evaluate().length, 1);
    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('RoundedButton - Displays button and handle click',
      (WidgetTester tester) async {
    bool btnClicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: RoundedButton(
          text: "Hello",
          onClick: () {
            btnClicked = true;
          },
        ),
      ),
    );

    var findByText = find.byType(Text);
    expect(findByText.evaluate().isEmpty, false);
    expect(findByText.evaluate().length, 1);
    expect(find.text('Hello'), findsOneWidget);

    var findByButton = find.byType(FlatButton);
    expect(findByButton.evaluate().isEmpty, false);
    expect(findByButton.evaluate().length, 1);

    await tester.tap(findByButton.first);
    expect(btnClicked, true);
  });
}
