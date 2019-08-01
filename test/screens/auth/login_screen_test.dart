import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynou/components/forms/loading_dialog.dart';
import 'package:lynou/components/forms/rounded_button.dart';
import 'package:lynou/models/env.dart';
import 'package:lynou/screens/auth/login_screen.dart';
import 'package:lynou/services/auth_service.dart';
import 'package:mockito/mockito.dart';

import '../../utils.dart';

class MockAuthService extends Mock implements AuthService {
  var env = Env(
    apiUrl: 'http://url_lynou_test.com',
    deviceId: 1,
    accessTokenKey: 'accessTokenKey',
    refreshTokenKey: 'refreshTokenKey',
    expiresInKey: 'expiresInKey',
  );

  // Mock up login
  Future<void> login(String email, String password) async {}
}

void main() {
  testWidgets('LoginScreen - Displaying', (WidgetTester tester) async {
    var widget = getMainContext(
      child: LoginScreen(),
      authService: MockAuthService(),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    var findByLoginScreen = find.byType(LoginScreen);
    expect(findByLoginScreen.evaluate().isEmpty, false);
  });

  testWidgets('LoginScreen - Click on login with empty inputs',
      (WidgetTester tester) async {
        var widget = getMainContext(
          child: LoginScreen(),
          authService: MockAuthService(),
    );

        await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    var findByLoginScreen = find.byType(LoginScreen);
    expect(findByLoginScreen.evaluate().isEmpty, false);

    var findByLoginButton = find.byType(RoundedButton);
    expect(findByLoginButton.evaluate().isEmpty, false);
    await tester.tap(findByLoginButton.first);
  });
}
