import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lynou/components/forms/error_form.dart';
import 'package:lynou/components/forms/loading_dialog.dart';
import 'package:lynou/models/api_error.dart';
import 'package:lynou/services/auth_service.dart';
import 'package:lynou/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:validate/validate.dart';
import 'package:lynou/components/forms/rounded_button.dart';
import 'package:lynou/components/forms/rounded_text_form.dart';
import 'package:lynou/localization/app_translations.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  bool _isPasswordHidden = true;
  final _passwordFocus = FocusNode();
  List<String> _errorList = [];

  AuthService _authService;

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

  /// Evaluates if the form values are correct
  /// If they are, we send the login query to the API
  /// Otherwise we display the errors
  _login() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      bool isValid = true;
      List<String> errorList = [];

      // Check the email
      if (_validateEmail(_emailController.text) != null) {
        isValid = false;
        errorList
            .add(AppTranslations.of(context).text("login_email_not_valid"));
      }

      // Check the password
      if (_validatePassword(_passwordController.text) != null) {
        isValid = false;
        errorList.add(
            AppTranslations.of(context).text("login_email_password_too_short"));
      }

      if (isValid) {
        // Login to the server
        try {
          await _authService.login(
              _emailController.text, _passwordController.text);

          setState(() {
            _isLoading = false;
          });

          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/main');
        } catch (e) {
          setState(() {
            _isLoading = false;
          });

          if (e is ApiError) {
            if (e.code == ERROR_EMAIL_OR_PASSWORD_INCORRECT) {
              errorList.add(AppTranslations.of(context)
                  .text("login_error_email_password_not_matching"));
            } else if (e.code == ERROR_SERVER) {
              errorList.add(AppTranslations.of(context).text("error_server"));
            } else {
              errorList.add(AppTranslations.of(context).text("error_server"));
            }
          } else {
            errorList.add(AppTranslations.of(context).text("error_server"));
          }
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }

      setState(() {
        _errorList = errorList;
      });

      // Hide the keyboard
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  /// When the email is submitted we focus the password field
  _onEmailSubmitted(String text) {
    FocusScope.of(context).requestFocus(_passwordFocus);
  }

  /// Displays the form to login
  /// The form contains: Email / Password / Forgot Password / Login button
  Widget _displayForm() {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          RoundedTextForm(
            key: Key("login_email"),
            textController: _emailController,
            hint: AppTranslations.of(context).text("login_email"),
            prefixIconData: Icons.email,
            textInputType: TextInputType.emailAddress,
            onSubmitted: _onEmailSubmitted,
          ),
          const SizedBox(
            height: 20.0,
          ),
          RoundedTextForm(
            key: Key("login_password"),
            focus: _passwordFocus,
            textController: _passwordController,
            hint: AppTranslations.of(context).text("login_password"),
            prefixIconData: Icons.lock,
            suffixIconData:
                _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
            obscureText: _isPasswordHidden,
            onSuffixIconClicked: _onPasswordVisibilityClicked,
            textInputAction: TextInputAction.done,
          ),
          // const SizedBox(
          //   height: 20.0,
          // ),
          // Text(
          //   AppTranslations.of(context).text("login_forgot_password"),
          //   style: TextStyle(color: RED_SECOND_COLOR),
          // ),
          const SizedBox(
            height: 30.0,
          ),
          RoundedButton(
            text: AppTranslations.of(context).text("login_sign_in"),
            onClick: _login,
          ),
        ],
      ),
    );
  }

  /// Displays the errors from the [_errorList]
  Widget _displayError() {
    if (_errorList.isNotEmpty) {
      return SizedBox(
        width: 300,
        child: ErrorForm(errorList: _errorList),
      );
    } else {
      return Container();
    }
  }

  /// Displays the footer which contains a label redirecting to the sign up page
  Widget _displayFooter() {
    return Container(
      key: Key('login_footer'),
      margin: EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/signup');
        },
        child: RichText(
          key: Key('login_footer_text'),
          text: TextSpan(
            children: [
              TextSpan(
                text: AppTranslations.of(context).text("login_no_account_yet"),
                style: TextStyle(color: Colors.white),
              ),
              TextSpan(
                text: AppTranslations.of(context).text("login_sign_up_here"),
                style: TextStyle(color: RED_SECOND_COLOR),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _authService = Provider.of<AuthService>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: LoadingDialog(
        isDisplayed: _isLoading,
        child: SingleChildScrollView(
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
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/login-background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _displayLogo(),
                    _displayForm(),
                    _displayError(),
                    _displayFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
