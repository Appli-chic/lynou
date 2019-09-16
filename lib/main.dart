import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lynou/localization/app_translations_delegate.dart';
import 'package:lynou/localization/application.dart';
import 'package:lynou/models/env.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:lynou/screens/auth/choose_theme_screen.dart';
import 'package:lynou/screens/auth/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lynou/screens/main_screen.dart';
import 'package:lynou/screens/auth/signup_screen.dart';
import 'package:lynou/screens/splash_screen.dart';
import 'package:lynou/services/auth_service.dart';
import 'package:lynou/services/post_service.dart';
import 'package:lynou/services/storage_service.dart';
import 'package:lynou/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'localization/timeago/fr_short_messages.dart';


void main() async {
  // Config locales for timeago
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('fr_short', FrShortMessages());

  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  AppTranslationsDelegate _newLocaleDelegate;
  Env _env = Env();

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;

    _onLoadEnvFile();
  }

  /// Load the env file which contains critic data
  void _onLoadEnvFile() async {
    _env = await EnvParser().load();
    setState(() {});
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
          value: AuthService(env: _env),
        ),
        Provider<UserService>.value(
          value: UserService(env: _env),
        ),
        Provider<PostService>.value(
          value: PostService(env: _env),
        ),
        Provider<StorageService>.value(
          value: StorageService(env: _env),
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
