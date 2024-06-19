import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFF00875F),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    color: Color(0xFF202024),
  ),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF00875F),
    secondary: Colors.grey[700]!,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(color: Colors.white),
    headlineMedium: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
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
);

Color appGrey = Color(0xFF808080);
