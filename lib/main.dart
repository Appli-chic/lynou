import 'package:flutter/material.dart';
import 'package:lynou/localization/app_translations_delegate.dart';
import 'package:lynou/localization/application.dart';
import 'package:lynou/models/env.dart';
import 'package:lynou/screens/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lynou/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() {
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

  void _onLoadEnvFile() async {
    _env = await EnvParser().load();
    setState(() {});
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>.value(
          value: AuthService(env: _env),
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
          '/': (context) => LoginScreen(),
        },
      ),
    );
  }
}
