import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lynou/components/forms/rounded_text_form.dart';
import 'package:lynou/models/api_error.dart';
import 'package:lynou/models/env.dart';
import 'package:lynou/screens/auth/login_screen.dart';
import 'package:lynou/screens/auth/signup_screen.dart';
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

  @override
  Future<void> login(String email, String password) {
    if (email == "test@error.fr" && password == "error-password") {
      throw ApiError(
          code: ERROR_EMAIL_PASSWORD_NOT_MATCHING,
          message: "ERROR_EMAIL_PASSWORD_NOT_MATCHING");
    } else if (email == "test@test.com" && password == "fds465f3") {
      return null;
    }

    throw ApiError(code: ERROR_SERVER, message: "error_server");
  }
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

        await tester.tap(find.text('login_sign_in'));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('login_email_not_valid'), findsOneWidget);
        expect(find.text('login_email_password_too_short'), findsOneWidget);
      });

  testWidgets('LoginScreen - Click on login with only a wrong email',
          (WidgetTester tester) async {
        var widget = getMainContext(
          child: LoginScreen(),
          authService: MockAuthService(),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(Key("login_email")), 'test');

        await tester.tap(find.text('login_sign_in'));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('login_email_not_valid'), findsOneWidget);
        expect(find.text('login_email_password_too_short'), findsOneWidget);
      });

  testWidgets('LoginScreen - Click on login with only a correct email',
          (WidgetTester tester) async {
        var widget = getMainContext(
          child: LoginScreen(),
          authService: MockAuthService(),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(Key("login_email")), 'test@test.com');

        await tester.tap(find.text('login_sign_in'));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('login_email_password_too_short'), findsOneWidget);
      });

  testWidgets('LoginScreen - Click on login with only a too short password',
          (WidgetTester tester) async {
        var widget = getMainContext(
          child: LoginScreen(),
          authService: MockAuthService(),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(Key("login_password")), 'fds43');

        await tester.tap(find.text('login_sign_in'));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('login_email_password_too_short'), findsOneWidget);
      });

  testWidgets('LoginScreen - Click on login with email and password',
          (WidgetTester tester) async {
        var widget = getMainContext(
          child: LoginScreen(),
          authService: MockAuthService(),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(Key("login_email")), 'test@test.com');
        await tester.enterText(find.byKey(Key("login_password")), 'fds465f3');

        await tester.tap(find.text('login_sign_in'));
        await tester.pump(const Duration(milliseconds: 100));
      });

  testWidgets('LoginScreen - Hide and show password',
          (WidgetTester tester) async {
        var widget = getMainContext(
          child: LoginScreen(),
          authService: MockAuthService(),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        var findLoginPassword = find.byKey(Key("login_password"));
        var passwordInput =
        findLoginPassword.evaluate().toList()[0].widget as RoundedTextForm;
        await tester.enterText(findLoginPassword, 'fds465f3');

        await tester.tap(find.byIcon(Icons.visibility));
        await tester.pump(const Duration(milliseconds: 100));
        passwordInput =
        findLoginPassword.evaluate().toList()[0].widget as RoundedTextForm;
        expect(passwordInput.obscureText, false);

        await tester.tap(find.byIcon(Icons.visibility_off));
        await tester.pump(const Duration(milliseconds: 100));
        passwordInput =
        findLoginPassword.evaluate().toList()[0].widget as RoundedTextForm;
        expect(passwordInput.obscureText, true);
      });

  testWidgets('LoginScreen - Login but wrong email and password',
          (WidgetTester tester) async {
        var widget = getMainContext(
          child: LoginScreen(),
          authService: MockAuthService(),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(Key("login_email")), 'test@error.fr');
        await tester.enterText(
            find.byKey(Key("login_password")), 'error-password');

        await tester.tap(find.text('login_sign_in'));
        await tester.pump(const Duration(milliseconds: 100));

        expect(
            find.text('login_error_email_password_not_matching'),
            findsOneWidget);
      });

  testWidgets('LoginScreen - Login with server error',
          (WidgetTester tester) async {
        var widget = getMainContext(
          child: LoginScreen(),
          authService: MockAuthService(),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(Key("login_email")), 'test@test.fr');
        await tester.enterText(
            find.byKey(Key("login_password")), 'error_server');

        await tester.tap(find.text('login_sign_in'));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('error_server'), findsWidgets);
      });

  testWidgets('LoginScreen - Click on \'sign up here\'',
          (WidgetTester tester) async {
        var widget = getMainContext(
            child: LoginScreen(),
            authService: MockAuthService(),
            routes: {
              '/signup': (context) => SignUpScreen(),
            });

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        expect(find.byKey(Key('login_footer_text')), findsOneWidget);
        await tester.tap(find.byKey(Key('login_footer_text')));
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();

        var findBySignUpScreen = find.byType(SignUpScreen);
        expect(findBySignUpScreen
            .evaluate()
            .isEmpty, false);
      });

  testWidgets('LoginScreen - Click on the background',
          (WidgetTester tester) async {
        var widget = getMainContext(
          child: LoginScreen(),
          authService: MockAuthService(),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        expect(find.byKey(Key('login_footer')), findsOneWidget);
        await tester.tap(find.byKey(Key('login_footer')));
        await tester.pump(const Duration(milliseconds: 100));
      });

  testWidgets('LoginScreen - Submit email -> focus password',
          (WidgetTester tester) async {
        var widget = getMainContext(
          child: LoginScreen(),
          authService: MockAuthService(),
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(Key("login_email")), 'test@error.fr');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();
  });
}
