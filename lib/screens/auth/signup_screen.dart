import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lynou/components/forms/error_form.dart';
import 'package:lynou/components/forms/loading_dialog.dart';
import 'package:lynou/components/forms/rounded_button.dart';
import 'package:lynou/components/forms/rounded_text_form.dart';
import 'package:lynou/localization/app_translations.dart';
import 'package:lynou/models/api_error.dart';
import 'package:lynou/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:validate/validate.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  final _nameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  List<String> _errorList = [];

  AuthService _authService;

  /// Display or hide the password
  _onPasswordVisibilityClicked() {
    setState(() {
      _isPasswordHidden = !_isPasswordHidden;
    });
  }

  /// Display or hide the confirmed password
  _onConfirmPasswordVisibilityClicked() {
    setState(() {
      _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
    });
  }

  /// When the email is submitted we focus the name field
  _onEmailSubmitted(String text) {
    FocusScope.of(context).requestFocus(_nameFocus);
  }

  /// When the name is submitted we focus the password field
  _onNameSubmitted(String text) {
    FocusScope.of(context).requestFocus(_passwordFocus);
  }

  /// When the password is submitted we focus the confirmed password field
  _onPasswordSubmitted(String text) {
    FocusScope.of(context).requestFocus(_confirmPasswordFocus);
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

  _signUp() async {
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

      // Check the name
      if (_nameController.text.isEmpty) {
        isValid = false;
        errorList.add(AppTranslations.of(context).text("sign_up_name_empty"));
      }

      // Check the password
      if (_validatePassword(_passwordController.text) != null) {
        isValid = false;
        errorList.add(
            AppTranslations.of(context).text("login_email_password_too_short"));
      }

      // Check the passwords are identical
      if (_passwordController.text != _confirmPasswordController.text) {
        isValid = false;
        errorList.add(AppTranslations.of(context)
            .text("sign_up_passwords_not_identical"));
      }

      if (isValid) {
        // Sign up the user
        try {
          await _authService.signUp(_emailController.text, _nameController.text,
              _passwordController.text);

          setState(() {
            _isLoading = false;
          });

          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/choose-theme');
        } catch (e) {
          setState(() {
            _isLoading = false;
          });

          if (e is ApiError) {
            if (e.code == ERROR_EMAIL_ALREADY_EXISTS) {
              errorList.add(AppTranslations.of(context)
                  .text("sign_up_email_already_exists"));
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

  /// Displays the form to register
  /// The form contains: Email / Name / Password / Verify password / register button
  Widget _displayForm() {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          RoundedTextForm(
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
            focus: _nameFocus,
            textController: _nameController,
            hint: AppTranslations.of(context).text("sign_up_name"),
            prefixIconData: Icons.person,
            onSubmitted: _onNameSubmitted,
          ),
          const SizedBox(
            height: 20.0,
          ),
          RoundedTextForm(
            focus: _passwordFocus,
            textController: _passwordController,
            hint: AppTranslations.of(context).text("login_password"),
            prefixIconData: Icons.lock,
            suffixIconData:
                _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
            obscureText: _isPasswordHidden,
            onSuffixIconClicked: _onPasswordVisibilityClicked,
            onSubmitted: _onPasswordSubmitted,
          ),
          const SizedBox(
            height: 30.0,
          ),
          RoundedTextForm(
            focus: _confirmPasswordFocus,
            textController: _confirmPasswordController,
            hint: AppTranslations.of(context).text("sign_up_verify_password"),
            prefixIconData: Icons.lock,
            suffixIconData: _isConfirmPasswordHidden
                ? Icons.visibility
                : Icons.visibility_off,
            obscureText: _isConfirmPasswordHidden,
            onSuffixIconClicked: _onConfirmPasswordVisibilityClicked,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(
            height: 30.0,
          ),
          RoundedButton(
            text: AppTranslations.of(context).text("sign_up_sign_up"),
            onClick: _signUp,
          ),
        ],
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
        child: Stack(
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
                        const SizedBox(
                          height: 30.0,
                        ),
                        _displayError(),
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
      ),
    );
  }
}
