import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color kPrimaryColor = Color(0xFF0D47A1); // Deep Blue
  static const Color kSecondaryColor = Color(0xFF1976D2); // Bright Blue
  static const Color kTextColor = Color(0xFF333333); // Dark Grey for text
  static const Color kErrorColor = Color(0xFFD32F2F); // Red for errors

  // Gradient
  static const LinearGradient kBackgroundGradient = LinearGradient(
    colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)], // Light blue gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    primaryColor: kPrimaryColor,
    colorScheme: ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: kTextColor),
      bodyMedium: TextStyle(color: kTextColor),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    primaryColor: kPrimaryColor,
    colorScheme: ColorScheme.dark(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}
