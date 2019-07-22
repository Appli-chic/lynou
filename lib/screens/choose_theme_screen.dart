import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lynou/components/rounded_button.dart';
import 'package:lynou/localization/app_translations.dart';
import 'package:lynou/utils/constants.dart';

enum ThemeEnum { dark, light }

class ChooseThemeScreen extends StatefulWidget {
  @override
  _ChooseThemeScreenState createState() => _ChooseThemeScreenState();
}

class _ChooseThemeScreenState extends State<ChooseThemeScreen> {
  ThemeEnum _themeEnum = ThemeEnum.dark;

  Widget _displayTitle() {
    return Center(
      child: Text(
        AppTranslations.of(context).text("choose_theme_select"),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 26.0,
        ),
      ),
    );
  }

  Widget _displayTheme(String imagePath, String title, ThemeEnum theme) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        setState(() {
          _themeEnum = theme;
        });
      },
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(8),
            child: Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            width: size.width / 2.4,
            height: size.height / 2,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(
                  const Radius.circular(8.0),
                ),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Radio(
            value: theme,
            groupValue: _themeEnum,
            onChanged: (ThemeEnum value) {
              setState(() {
                _themeEnum = value;
              });
            },
            activeColor: Colors.red,
          ),
        ],
      ),
    );
  }

  _onNextButtonClicked() async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: KEY_THEME, value: _themeEnum.index.toString());

    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: Theme(
        data: ThemeData.dark(),
        child: Container(
          color: BACKGROUND_COLOR,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _displayTitle(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _displayTheme(
                    'assets/dark_theme.png',
                    AppTranslations.of(context).text("choose_theme_dark"),
                    ThemeEnum.dark,
                  ),
                  _displayTheme(
                    'assets/light_theme.png',
                    AppTranslations.of(context).text("choose_theme_light"),
                    ThemeEnum.light,
                  ),
                ],
              ),
              Container(
                width: 150,
                child: RoundedButton(
                  text: AppTranslations.of(context).text("next"),
                  onClick: _onNextButtonClicked,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
