import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFF00875F),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900],
    centerTitle: true,
    elevation: 0,
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w800,
      // height: 1, // line-height = font-size * height (30 / 20 = 1.5)
      fontFamily: 'Poppins',
    ),
  ),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF00875F),
    secondary: Colors.grey[700]!,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
    headlineMedium: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
    bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
    bodyMedium: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 14),
  ),

  buttonTheme: const ButtonThemeData(
    buttonColor: Color(0xFF00875F),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[800],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: Color(0xFF00875F)),
    ),
  ),
  fontFamily: 'Poppins',
);

Color appGrey = Color(0xFF808080);
Color appDarkGreen = Color(0xFF00875F);
Color appLightGreen = Color(0xFF00B37E);
