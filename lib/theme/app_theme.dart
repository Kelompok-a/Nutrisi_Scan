import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color kPrimaryColor = Color.fromARGB(255, 41, 70, 234);
  static const Color kPrimaryLightColor = Color(0xFFC5CAE9);
  static const Color kErrorColor = Color.fromARGB(255, 249, 0, 0);
  static const Color kTextColor = Color(0xFF212121);
  static const Color kTextLightColor = Color.fromARGB(255, 79, 79, 79);
  static const Color kGradientStart = Color(0xFFEDE7F6);
  static const Color kGradientEnd = Color(0xFFE3F2FD);

  static const LinearGradient kBackgroundGradient = LinearGradient(
    colors: [kGradientStart, kGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final ThemeData lightTheme = ThemeData(
    primaryColor: kPrimaryColor,
    primarySwatch: _createMaterialColor(kPrimaryColor),
    scaffoldBackgroundColor: Colors.transparent,
    visualDensity: VisualDensity.adaptivePlatformDensity,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: kTextColor,
      iconTheme: IconThemeData(color: kTextColor),
      titleTextStyle: TextStyle(
        color: kTextColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 2.0,
      color: Colors.white.withAlpha(230),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kPrimaryColor,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: kPrimaryColor, width: 2.0),
      ),
      labelStyle: const TextStyle(color: kTextLightColor),
      hintStyle: const TextStyle(color: kTextLightColor),
    ),
  );

  static MaterialColor _createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }
}
