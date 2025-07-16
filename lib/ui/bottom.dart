import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/app_constants.dart' as constants;
import 'package:mediary/ui/all_media_screen.dart';
import 'package:mediary/ui/profile_screen.dart';

class AppNavigationBar extends StatefulWidget {
  const AppNavigationBar({super.key});

  @override
  State<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  int currentIndex = 0;

  Widget _getCurrentPage(int index) {
    switch (index) {
      case 0:
        return Home();
      case 1:
        return ProfileScreen();
      default:
        return Home();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getCurrentPage(currentIndex),
      bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          height: 70,
          backgroundColor: myColors.mediumGreenColor,
          onDestinationSelected: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide.none,
          ),
          indicatorColor: myColors.lightGreenColor,
          selectedIndex: currentIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home, size: 36),
              icon: Icon(Icons.home_outlined, size: 30),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person, size: 36),
              icon: Icon(Icons.person_outlined, size: 30),
              label: 'Profile',
            ),
          ]),
    );
  }
}
