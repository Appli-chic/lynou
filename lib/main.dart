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
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'localization/timeago/fr_short_messages.dart';

void _handleNotificationReceived(OSNotification notification) {

}

void main() async {
  // Config locales for timeago
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('fr_short', FrShortMessages());

  // Set up the mobile push
  OneSignal.shared.init(
      "7697b3a4-a33a-49c3-bb14-4cdda502419d",
      iOSSettings: {
        OSiOSSettings.autoPrompt: false,
        OSiOSSettings.inAppLaunchUrl: true
      }
  );
  OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

  OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
    // will be called whenever a notification is received
  });

  OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // will be called whenever a notification is opened/button pressed.
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    // will be called whenever the permission changes
    // (ie. user taps Allow on the permission prompt in iOS)
  });

  OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    // will be called whenever the subscription changes
    //(ie. user gets registered with OneSignal and gets a user ID)
  });

  OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges emailChanges) {
    // will be called whenever then user's email subscription changes
    // (ie. OneSignal.setEmail(email) is called and the user gets registered
  });

  OneSignal.shared.setNotificationReceivedHandler(_handleNotificationReceived);
  OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);

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
