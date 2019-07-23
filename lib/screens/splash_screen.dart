import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lynou/services/auth_service.dart';
import 'package:lynou/utils/constants.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthService _authService;

  /// Check if the user is logged in and redirect to the right page
  /// The home page if the user is logged in
  /// The login page if the user needs to login
  _checkIsLoggedIn() async {
    bool _isLoggedIn = await _authService.isLoggedIn();

    if (_isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  /// Displays Lynou's logo in the top of this page
  Widget _displayLogo() {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        child: Placeholder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _authService = Provider.of<AuthService>(context);
    _checkIsLoggedIn();

    return Container(
      color: BACKGROUND_COLOR,
      child: _displayLogo(),
    );
  }
}
