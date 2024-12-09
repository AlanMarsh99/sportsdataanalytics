import 'package:flutter/material.dart';

const Color primary = Color(0xFF1B222C);
const Color secondary = Color(0xFFEE0000);
const Color redAccent = Color(0xFFFF3E3E);
const Color gray1 = Color(0xFFB7B7B7);
const Color gray2 = Color(0xFFD9D9D9);
const Color gray3 = Color(0xFFE6E6E6);
const Color white = Color(0xFFF5F5F5);
const Color darkGradient = Color(0xFF1D2939);
const Color lightGradient = Color(0xFF475468);

ThemeData theme = ThemeData(
  scaffoldBackgroundColor: Colors.transparent,
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: primary,
    iconTheme: IconThemeData(
      color: primary,
    ),
  ),
  primaryTextTheme: textTheme,
  textTheme: textTheme,
  navigationRailTheme: NavigationRailThemeData(
    backgroundColor: primary,
    elevation: 1.0,
    selectedIconTheme: primaryIconThemeData,
    selectedLabelTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    unselectedIconTheme: IconThemeData(
      color: Colors.white,
    ),
    unselectedLabelTextStyle: TextStyle(
      color: Colors.white,
    ),
  ),
  iconTheme: IconThemeData(
    color: primary,
  ),
  inputDecorationTheme: InputDecorationTheme(
    errorStyle: TextStyle(
      fontSize: 14.0,
      color: Colors.red,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primary,
      padding: EdgeInsets.all(16.0),
      textStyle: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
);

IconThemeData primaryIconThemeData = IconThemeData(
  color: Colors.white,
);

TextTheme textTheme = const TextTheme(
  bodyLarge: TextStyle(
    fontFamily: 'Poppins',
    color: Colors.white,
  ),
  bodyMedium: TextStyle(
    fontFamily: 'Poppins',
    color: Colors.white,
  ),
  displayLarge: TextStyle(
    fontFamily: 'Poppins',
    fontSize: 40,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  ),
  displayMedium: TextStyle(
    fontFamily: 'Poppins',
    color: Colors.white,
  ),
  displaySmall: TextStyle(
    fontFamily: 'Poppins',
    color: Colors.white,
  ),
  headlineMedium: TextStyle(
    fontFamily: 'Poppins',
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 40,
  ),
  headlineSmall: TextStyle(
    fontFamily: 'Poppins',
    color: Colors.white,
  ),
  titleLarge: TextStyle(
    fontFamily: 'Poppins',
    color: Colors.white,
  ),
  labelLarge: TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
);
