import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynou/components/forms/rounded_text_form.dart';

main() {
  testWidgets('RoundedTextForm - Displays with a hint',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: RoundedTextForm(hint: "email"),
        ),
      ),
    );

    var findByTextField = find.byType(TextField);
    expect(findByTextField.evaluate().isEmpty, false);
    expect(findByTextField.evaluate().length, 1);
    expect(find.text("email"), findsOneWidget);

    var textField = findByTextField.evaluate().toList()[0].widget as TextField;
    expect(textField.obscureText, false);
    expect(textField.textInputAction, TextInputAction.next);
    expect(textField.keyboardType, TextInputType.text);
  });

  testWidgets('RoundedTextForm - Displays with icons',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: RoundedTextForm(
            hint: "email",
            prefixIconData: Icons.lock,
            suffixIconData: Icons.panorama_fish_eye,
          ),
        ),
      ),
    );

    var findByLockIcon = find.byIcon(Icons.lock);
    expect(findByLockIcon.evaluate().isEmpty, false);
    expect(findByLockIcon.evaluate().length, 1);

    var findByEyeIcon = find.byIcon(Icons.panorama_fish_eye);
    expect(findByEyeIcon.evaluate().isEmpty, false);
    expect(findByEyeIcon.evaluate().length, 1);
  });

  testWidgets('RoundedTextForm - Displays and handle suffix icon click',
      (WidgetTester tester) async {
    bool suffixIconClicked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: RoundedTextForm(
            hint: "email",
            suffixIconData: Icons.panorama_fish_eye,
            onSuffixIconClicked: () {
              suffixIconClicked = true;
            },
          ),
        ),
      ),
    );

    var findByTextField = find.byType(TextField);
    var findByEyeIcon = find.byIcon(Icons.panorama_fish_eye);

    await tester.tap(findByEyeIcon.first);
    expect(suffixIconClicked, true);

    var textField = findByTextField.evaluate().toList()[0].widget as TextField;
    expect(textField.obscureText, false);
  });

  testWidgets('RoundedTextForm - Displays with params',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: RoundedTextForm(
            hint: "email",
            obscureText: true,
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.emailAddress,
          ),
        ),
      ),
    );

    var findByTextField = find.byType(TextField);
    var textField = findByTextField.evaluate().toList()[0].widget as TextField;
    expect(textField.obscureText, true);
    expect(textField.textInputAction, TextInputAction.done);
    expect(textField.keyboardType, TextInputType.emailAddress);
  });
}
