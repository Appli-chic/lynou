import 'package:flutter/material.dart';
import 'package:lynou/utils/constants.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lynou'),
        backgroundColor: BACKGROUND_COLOR,
        elevation: 0,
      ),
      body: Container(
        color: BACKGROUND_COLOR,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: BACKGROUND_COLOR,
        elevation: 0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            activeIcon: ShaderMask(
              shaderCallback: (Rect rect) {
                return LinearGradient(
                  colors: <Color>[
                    RED_FIRST_COLOR,
                    RED_SECOND_COLOR,
                  ],
                ).createShader(rect);
              },
              child: Icon(Icons.home),
            ),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble, color: Colors.white),
            activeIcon: Icon(Icons.chat_bubble),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder, color: Colors.white),
            activeIcon: Icon(Icons.folder),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.white),
            activeIcon: Icon(Icons.search),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            activeIcon: Icon(Icons.person),
            title: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
