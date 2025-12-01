import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Premium Health Blue Palette
  static const Color kPrimaryColor = Color(0xFF1E40AF); // Royal Blue (Darker, Premium)
  static const Color kSecondaryColor = Color(0xFF3B82F6); // Bright Blue
  static const Color kAccentColor = Color(0xFF60A5FA); // Light Blue
  static const Color kBackgroundColor = Color(0xFFF8FAFC); // Slate 50 (Clean White-ish)
  static const Color kSurfaceColor = Colors.white;
  static const Color kTextColor = Color(0xFF1E293B); // Slate 800
  static const Color kSubTextColor = Color(0xFF64748B); // Slate 500
  static const Color kSuccessColor = Color(0xFF10B981); // Emerald 500
  static const Color kErrorColor = Color(0xFFEF4444); // Red 500

  static const LinearGradient kPrimaryGradient = LinearGradient(
    colors: [kPrimaryColor, kSecondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient kBackgroundGradient = LinearGradient(
    colors: [Color(0xFFEFF6FF), Color(0xFFF8FAFC)], // Very subtle blue tint to white
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: kBackgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kPrimaryColor,
        primary: kPrimaryColor,
        secondary: kSecondaryColor,
        surface: kSurfaceColor,
        background: kBackgroundColor,
        error: kErrorColor,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(
        bodyColor: kTextColor,
        displayColor: kTextColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: kSurfaceColor,
        foregroundColor: kTextColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: kTextColor,
        ),
        iconTheme: const IconThemeData(color: kTextColor),
      ),
      cardTheme: CardThemeData(
        color: kSurfaceColor,
        elevation: 2,
        shadowColor: kPrimaryColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kSubTextColor.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kSubTextColor.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPrimaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: kPrimaryColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
      colorScheme: ColorScheme.fromSeed(
        seedColor: kPrimaryColor,
        brightness: Brightness.dark,
        primary: kPrimaryColor,
        secondary: kSecondaryColor,
        surface: const Color(0xFF1E293B), // Slate 800
        background: const Color(0xFF0F172A),
        error: kErrorColor,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E293B),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPrimaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: kPrimaryColor.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
