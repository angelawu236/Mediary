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
}

class Titles {
  static const homeTitle = 'My Media';
}

const textFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: myColors.mediumGreenColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: myColors.darkGreenColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);
