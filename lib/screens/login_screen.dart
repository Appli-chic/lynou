import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lynou/components/rounded_text_form.dart';
import 'package:lynou/localization/app_translations.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  bool _isPasswordHidden = false;

  /// Displays the background image in this page
  Widget _displayBackground() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/login-background.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Displays Lynou's logo in the top of this page
  Widget _displayLogo() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        margin: EdgeInsets.only(top: kToolbarHeight),
        child: Placeholder(),
      ),
    );
  }

  /// Displays the form to login
  /// The form contains: Email / Password / Forgot Password / Login button
  Widget _displayForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          RoundedTextForm(
            hint: AppTranslations.of(context).text("login_email"),
            prefixIconData: Icons.email,
          ),
          const SizedBox(
            height: 20.0,
          ),
          RoundedTextForm(
            hint: AppTranslations.of(context).text("login_password"),
            prefixIconData: Icons.lock,
            suffixIconData:
                _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
            obscureText: true,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _displayBackground(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _displayLogo(),
              _displayForm(),
              _displayLogo(),
            ],
          ),
        ],
      ),
    );
  }
}
