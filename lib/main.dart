import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lynou/localization/app_translations_delegate.dart';
import 'package:lynou/localization/application.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:lynou/screens/auth/choose_theme_screen.dart';
import 'package:lynou/screens/auth/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lynou/screens/main_screen.dart';
import 'package:lynou/screens/auth/signup_screen.dart';
import 'package:lynou/screens/splash_screen.dart';
import 'package:lynou/services/auth_service.dart';
import 'package:lynou/utils/firebase-config.dart';
import 'package:provider/provider.dart';

void main() async {
  var _fireBaseConfig = FireBaseConfig();
  await _fireBaseConfig.initFireBase();

  FirebaseAuth.instance.signOut();

  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null, isTest: false);
    application.onLocaleChanged = onLocaleChange;
  }

  /// Triggers when the [locale] changes
  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MultiProvider(
      providers: [
        Provider<AuthService>.value(
          value: AuthService(),
        ),
        ChangeNotifierProvider<ThemeProvider>.value(
          value: ThemeProvider(),
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
        initialRoute: '/',
        routes: {
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/choose-theme': (context) => ChooseThemeScreen(),
          '/': (context) => SplashScreen(),
          '/main': (context) => MainScreen(),
        },
      ),
    );
  }
}
