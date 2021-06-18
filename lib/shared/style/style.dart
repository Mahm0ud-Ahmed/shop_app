import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

// Light Theme
ThemeData themeLight = ThemeData(
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(
      color: colorAcc,
    ),
    color: Colors.white,
    backwardsCompatibility: false,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 24,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  ),
  brightness: Brightness.light,
  fontFamily: 'Baloo',
  textTheme: TextTheme(
    headline4: TextStyle(
      color: Colors.indigo.shade700,
      fontWeight: FontWeight.bold,
    ),
    headline6: TextStyle(
      color: Colors.grey,
    ),
  ),
  accentColor: colorAcc,
  primaryColor: colorPrim,
  iconTheme: IconThemeData(
    size: 16,
  ),
  buttonColor: Colors.lightGreen,
  scaffoldBackgroundColor: Colors.white,
);

// Dark Theme
ThemeData themeDark = ThemeData(
  backgroundColor: Color.fromRGBO(38, 38, 38, 1),
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(
      color: colorAcc,
    ),
    color: Colors.grey.shade600,
    backwardsCompatibility: false,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 24,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  ),
  brightness: Brightness.dark,
  fontFamily: 'Baloo',
  textTheme: TextTheme(
    headline4: TextStyle(
      color: Colors.indigo.shade700,
      fontWeight: FontWeight.bold,
    ),
    headline6: TextStyle(
      color: Colors.grey,
    ),
  ),
  accentColor: colorAcc,
  primaryColor: Colors.blue,
  iconTheme: IconThemeData(
    size: 16,
  ),
  buttonColor: Colors.deepPurpleAccent,
  scaffoldBackgroundColor: Color.fromRGBO(38, 38, 38, 1),
);
