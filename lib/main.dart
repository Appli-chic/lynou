import 'package:flutter/material.dart';
import 'package:lynou/screens/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('fr'), // French
      ],
      initialRoute: '/',
      routes: {
        '/login': (context) => LoginScreen(),
        '/': (context) => LoginScreen(),
      },
    );
  }
}
