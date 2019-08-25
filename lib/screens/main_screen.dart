import 'package:flutter/material.dart';
import 'package:lynou/components/general/icon.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:lynou/screens/chat_screen.dart';
import 'package:lynou/screens/home_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ThemeProvider _themeProvider;

  PageController _pageController = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Changes the displayed tab to the specified [index]
  onTabClicked(int index) {
    setState(() {
      _index = index;
    });

    _pageController.jumpToPage(index);
  }

  /// Displays the bottom navigation bar
  BottomNavigationBar _displayBottomBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: _themeProvider.backgroundColor,
      elevation: 0,
      currentIndex: _index,
      onTap: onTabClicked,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: LYIcon(iconData: Icons.home, color: _themeProvider.textColor),
          activeIcon: LYIcon(iconData: Icons.home, theme: _themeProvider.theme),
          title: const SizedBox(),
        ),
        BottomNavigationBarItem(
          icon: LYIcon(
              iconData: Icons.chat_bubble, color: _themeProvider.textColor),
          activeIcon:
              LYIcon(iconData: Icons.chat_bubble, theme: _themeProvider.theme),
          title: const SizedBox(),
        ),
        BottomNavigationBarItem(
          icon: LYIcon(iconData: Icons.search, color: _themeProvider.textColor),
          activeIcon:
              LYIcon(iconData: Icons.search, theme: _themeProvider.theme),
          title: const SizedBox(),
        ),
        BottomNavigationBarItem(
          icon: LYIcon(iconData: Icons.person, color: _themeProvider.textColor),
          activeIcon:
              LYIcon(iconData: Icons.person, theme: _themeProvider.theme),
          title: const SizedBox(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          HomeScreen(),
          ChatScreen(),
          ChatScreen(),
          ChatScreen(),
          ChatScreen(),
        ],
      ),
      bottomNavigationBar: _displayBottomBar(),
    );
  }
}
