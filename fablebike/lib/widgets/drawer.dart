import 'package:fablebike/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:fablebike/pages/routes.dart';
import '../pages/home.dart';

Widget _buildMenuItem(BuildContext context, Widget title, String routeName, String currentRoute) {
  var isSelected = routeName == currentRoute;

  return ListTile(
    title: title,
    selected: isSelected,
    onTap: () {
      if (isSelected) {
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, routeName);
      }
    },
  );
}

BottomNavigationBar buildBottomBar(BuildContext context, String currentRoute) {
  double w = 40;
  double h = 40;

  return BottomNavigationBar(
      onTap: (int index) {
        switch (index) {
          case 0:
            if (currentRoute == HomeScreen.route) {
              if (currentRoute != ModalRoute.of(context).settings.name) {
                Navigator.pop(context);
              }
              return;
            }
            Navigator.pushReplacementNamed(context, HomeScreen.route);
            break;
          case 1:
            if (currentRoute == RoutesScreen.route) {
              if (currentRoute != ModalRoute.of(context).settings.name) {
                Navigator.pop(context);
              }
              return;
            }
            Navigator.pushReplacementNamed(context, RoutesScreen.route);
            break;
          case 2:
            if (currentRoute == SettingsScreen.route) {
              if (currentRoute != ModalRoute.of(context).settings.name) {
                Navigator.pop(context);
              }
              return;
            }
            Navigator.pushReplacementNamed(context, SettingsScreen.route);
            break;
        }
      },
      iconSize: 18,
      elevation: 36.0,
      selectedItemColor: Theme.of(context).primaryColor,
      currentIndex: currentRoute == HomeScreen.route
          ? 0
          : currentRoute == RoutesScreen.route
              ? 1
              : 2,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: currentRoute != HomeScreen.route
              ? Image.asset('assets/icons/home.png', width: w, height: h)
              : Image.asset('assets/icons/home_h.png', width: w, height: h),
          label: 'Acasa',
        ),
        BottomNavigationBarItem(
          icon: currentRoute != RoutesScreen.route
              ? Image.asset('assets/icons/explore.png', width: w, height: h)
              : Image.asset('assets/icons/explore_h.png', width: w, height: h),
          label: 'Exploreaza',
        ),
        BottomNavigationBarItem(
          icon: currentRoute != SettingsScreen.route
              ? Image.asset('assets/icons/settings.png', width: w, height: h)
              : Image.asset('assets/icons/settings_h.png', width: w, height: h),
          label: 'Contul meu',
        ),
      ]);
}
