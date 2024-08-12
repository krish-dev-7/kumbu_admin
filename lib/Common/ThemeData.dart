import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: appDarkGreen, // Netflix red
  scaffoldBackgroundColor: Color(0xffffffff), // Light background
  appBarTheme: AppBarTheme(
    backgroundColor: appDarkGreen, // Netflix red
    centerTitle: true,
    elevation: 0,
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w800,
      fontFamily: 'Poppins',
    ),
    iconTheme: IconThemeData(color: Colors.white)
  ),
  colorScheme: ColorScheme.light(
    primary: appDarkGreen, // Netflix red
    secondary: appGrey, // Light gray for secondary text and elements
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
    headlineMedium: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
    bodyLarge: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
    bodyMedium: TextStyle(color: Color(0xff333333), fontFamily: 'Poppins', fontSize: 14), // Dark gray for less prominent text
  ),
  buttonTheme:  ButtonThemeData(
    buttonColor: appDarkGreen, // Netflix red
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xfff5f5f5), // Light gray background for input fields
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: appDarkGreen), // Netflix red
    ),
  ),
  fontFamily: 'Poppins',
);

Color appGrey = Color(0xffb3b3b3); // Light gray for general use
Color appDarkGreen = Color(0xff9f0209); // Netflix red for buttons or highlights
Color appLightGreen = Color(0xff6a5556); // Light gray for backgrounds or less prominent elements
Color appTextColor = Color(0xff433536); // Light gray for backgrounds or less prominent elements
Color appMediumColor = Color(0xff911c24); // Light gray for backgrounds or less prominent elements
Color appContainerColors = Color(0xfffffafa); // Light gray for backgrounds or less prominent elements
Color appBackgroundColor = Color(0xffffffff);

void loadSavedColors() async {
  print(appDarkGreen.value);
  final prefs = await SharedPreferences.getInstance();
    appGrey = Color(prefs.getInt('appGrey') ?? 0xffb3b3b3);
    appDarkGreen = Color(prefs.getInt('appDarkGreen') ?? 0xff9f0209);
    appLightGreen = Color(prefs.getInt('appLightGreen') ?? 0xff775e5f);
    appMediumColor = Color(prefs.getInt('appMediumColor') ?? 0xffc15151);
    appBackgroundColor = Color(prefs.getInt('appBackgroundColor') ?? 0xffffffff);
    print(appDarkGreen.value);
}
