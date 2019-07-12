import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validate/validate.dart';
import 'package:lynou/components/rounded_button.dart';
import 'package:lynou/components/rounded_text_form.dart';
import 'package:lynou/localization/app_translations.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  bool _isPasswordHidden = true;

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

  /// Display or hide the password
  _onPasswordVisibilityClicked() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  /// Evaluates if the [value] is corresponding to an email
  String _validateEmail(String value) {
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'L\'adresse email doit être une adresse valide';
    }

    return null;
  }

  /// Evaluates if the [value] is corresponding to a valid password.
  /// A valid password must contains at least 6 characters
  String _validatePassword(String value) {
    if (value.length < 6) {
      return 'Le mot de passe doit faire au moins 6 charactères';
    }

    return null;
  }

  /// Displays the form to login
  /// The form contains: Email / Password / Forgot Password / Login button
  Widget _displayForm() {
    return Form(
      key: _formKey,
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            RoundedTextForm(
              hint: AppTranslations.of(context).text("login_email"),
              prefixIconData: Icons.email,
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 20.0,
            ),
            RoundedTextForm(
              hint: AppTranslations.of(context).text("login_password"),
              prefixIconData: Icons.lock,
              suffixIconData:
                  _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
              obscureText: _isPasswordHidden,
              onSuffixIconClicked: _onPasswordVisibilityClicked,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              AppTranslations.of(context).text("login_forgot_password"),
              style: TextStyle(color: Color.fromARGB(255, 239, 71, 58)),
            ),
            const SizedBox(
              height: 30.0,
            ),
            RoundedButton(
              text: AppTranslations.of(context).text("login_sign_in"),
            ),
          ],
        ),
      ),
    );
  }

  /// Displays the footer which contains a label redirecting to the sign up page
  Widget _displayFooter() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppTranslations.of(context).text("login_no_account_yet"),
              style: TextStyle(color: Colors.white),
            ),
            TextSpan(
              text: AppTranslations.of(context).text("login_sign_up_here"),
              style: TextStyle(color: Color(0xFFEF473A)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Hides the keyboard when we click outside of the textfields
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            _displayBackground(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _displayLogo(),
                _displayForm(),
                _displayFooter(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
