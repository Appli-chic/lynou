import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lynou/components/rounded_button.dart';
import 'package:lynou/components/rounded_text_form.dart';
import 'package:lynou/localization/app_translations.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  /// Displays the form to register
  /// The form contains: Email / Name / Password / Verify password / register button
  Widget _displayForm() {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          RoundedTextForm(
            // textController: _emailController,
            hint: AppTranslations.of(context).text("login_email"),
            prefixIconData: Icons.email,
            textInputType: TextInputType.emailAddress,
            // onSubmitted: _onEmailSubmitted,
          ),
          const SizedBox(
            height: 20.0,
          ),
          RoundedTextForm(
            // textController: _emailController,
            hint: "Nom",
            prefixIconData: Icons.person,
            textInputType: TextInputType.emailAddress,
            // onSubmitted: _onEmailSubmitted,
          ),
          const SizedBox(
            height: 20.0,
          ),
          RoundedTextForm(
            // focus: _passwordFocus,
            // textController: _passwordController,
            hint: AppTranslations.of(context).text("login_password"),
            prefixIconData: Icons.lock,
            // suffixIconData:
            //     _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
            // obscureText: _isPasswordHidden,
            // onSuffixIconClicked: _onPasswordVisibilityClicked,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(
            height: 30.0,
          ),
          RoundedTextForm(
            // focus: _passwordFocus,
            // textController: _passwordController,
            hint: AppTranslations.of(context).text("login_password"),
            prefixIconData: Icons.lock,
            // suffixIconData:
            //     _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
            // obscureText: _isPasswordHidden,
            // onSuffixIconClicked: _onPasswordVisibilityClicked,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(
            height: 30.0,
          ),
          RoundedButton(
            text: AppTranslations.of(context).text("login_sign_in"),
            // onClick: _login,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height,
                minWidth: size.width,
              ),
              child: GestureDetector(
                onTap: () {
                  // Hides the keyboard when we click outside of the textfields
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  padding: EdgeInsets.only(top: kToolbarHeight),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/login-background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _displayForm(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
          ),
        ],
      ),
    );
  }
}
