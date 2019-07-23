import 'package:flutter/material.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ThemeProvider _themeProvider;

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lynou'),
        backgroundColor: _themeProvider.getBackgroundColor,
        elevation: 0,
      ),
      body: Container(
        color: _themeProvider.getBackgroundColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: _themeProvider.getBackgroundColor,
        elevation: 0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _themeProvider.getTextColor),
            activeIcon: ShaderMask(
              shaderCallback: (Rect rect) {
                return LinearGradient(
                  colors: <Color>[
                    _themeProvider.getFirstColor,
                    _themeProvider.getSecondColor,
                  ],
                ).createShader(rect);
              },
              child: Icon(Icons.home),
            ),
            title: const SizedBox(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble, color: _themeProvider.getTextColor),
            activeIcon: Icon(Icons.chat_bubble),
            title: const SizedBox(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder, color: _themeProvider.getTextColor),
            activeIcon: Icon(Icons.folder),
            title: const SizedBox(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: _themeProvider.getTextColor),
            activeIcon: Icon(Icons.search),
            title: const SizedBox(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _themeProvider.getTextColor),
            activeIcon: Icon(Icons.person),
            title: const SizedBox(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _themeProvider.setTheme(1);
        },
        child: Icon(Icons.plus_one),
        backgroundColor: Colors.red,
      ),
    );
  }
}
