import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynou/components/forms/error_form.dart';

void main() {
  testWidgets('ErrorForm - Displays one error', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ErrorForm(errorList: ['Only one error']),
      ),
    );

    var findByText = find.byType(Text);
    expect(findByText.evaluate().isEmpty, false);
    expect(findByText.evaluate().length, 1);
    expect(find.text('Only one error'), findsOneWidget);
  });

  testWidgets('ErrorForm - Displays two errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ErrorForm(errorList: ['One error', 'Two error']),
      ),
    );

    var findByText = find.byType(Text);
    expect(findByText.evaluate().isEmpty, false);
    expect(findByText.evaluate().length, 2);
    expect(find.text('One error'), findsOneWidget);
    expect(find.text('Two error'), findsOneWidget);
  });

  testWidgets('ErrorForm - Displays no error', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ErrorForm(errorList: []),
      ),
    );

    var findByText = find.byType(Text);
    expect(findByText.evaluate().isEmpty, true);
  });
}
