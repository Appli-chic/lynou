import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lynou/localization/app_translations.dart';
import 'package:lynou/localization/app_translations_delegate.dart';
import 'package:lynou/models/env.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:lynou/services/auth_service.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockThemeProvider extends Mock implements ThemeProvider {}

Widget getMainContext({Widget child, AuthService authService}) {
  var _newLocaleDelegate = AppTranslationsDelegate(
      newLocale: Locale('en', ''), isTest: true);

  var _env = Env(
    apiUrl: 'http://url_lynou_test.com',
    deviceId: 1,
    accessTokenKey: 'accessTokenKey',
    refreshTokenKey: 'refreshTokenKey',
    expiresInKey: 'expiresInKey',
  );

  // add Services or Mocked services
  var _authService = authService == null ? AuthService(env: _env) : authService;

  return MultiProvider(
    providers: [
      Provider<AuthService>.value(
        value: _authService,
      ),
      ChangeNotifierProvider<MockThemeProvider>.value(
        value: MockThemeProvider(),
      ),
    ],
    child: MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      localizationsDelegates: [
        _newLocaleDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English
        const Locale('fr', ''), // French
      ],
      home: child,
    ),
  );
}
