import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todoset/screen/home_page.dart';
import 'package:todoset/screen/set_page.dart';
import 'package:todoset/screen/setting_page.dart';

class NavBar extends StatefulWidget {
  static const String id = 'navi_bottom';
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0;
  final screens = [
    const HomePage(),
    const SetPage(),
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Ionicons.list_outline),
              label: "Tasks",
            ),
            BottomNavigationBarItem(
                icon: Icon(Ionicons.grid_outline), label: "ToDoSet"),
            BottomNavigationBarItem(
                icon: Icon(Ionicons.settings_outline), label: "Setting")
          ],
        ),
      );
}
