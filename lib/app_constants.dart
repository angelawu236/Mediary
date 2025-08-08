import 'package:flutter/material.dart';
import 'package:mediary/app_styles.dart' as myColors;
import 'package:mediary/app_constants.dart' as constants;

class RoutePaths{
  static const String Home = '/';
  static const String NavBar = 'navigation_bar';
  static const String LoginScreen = 'login_screen';
  static const String RegisterScreen = 'register_screen';
  static const String MediaItems = "media_items";
  static const String MediaList = "media_list";
  static const String AddCategory = "add_category";
  static const String Bottom = "bottom_nav";
  static const String Profile = "profile";
}

class Titles {
  static const homeTitle = 'My Media';
}

const textFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: myColors.brightOutlineColor),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: myColors.brightOutlineColor, width: 1.0), // 🟧
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: myColors.brightOutlineColor, width: 2.0), // 🟧
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

const textFieldDecoration2 = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: myColors.lightTextColor),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: myColors.lightTextColor, width: 1.0), // 🟧
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: myColors.lightTextColor, width: 2.0), // 🟧
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

