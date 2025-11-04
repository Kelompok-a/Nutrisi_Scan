// lib/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // =======================================================
  // PALET WARNA BARU (BIRU PROFESIONAL)
  // =======================================================
  static const Color kPrimaryColor = Color(0xFF0056b3); // Biru Utama
  static const Color kPrimaryLightColor = Color(0xFFBBDEFB); // Biru Muda
  static const Color kErrorColor = Color(0xFFD32F2F);   // Merah
  
  static const Color kTextColor = Color(0xFF212121);    // Abu-abu tua
  static const Color kTextLightColor = Color(0xFF757575); // Abu-abu

  // =======================================================
  // GRADIENT BACKGROUND BARU (BIRU LANGIT)
  // =======================================================
  static const Color kGradientStart = Color(0xFFE3F2FD); // Biru Langit (Blue 50)
  static const Color kGradientEnd = Color(0xFFFFFFFF);   // Putih

  static const LinearGradient kBackgroundGradient = LinearGradient(
    colors: [kGradientStart, kGradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // =======================================================
  // DEFINISI THEME UTAMA
  // =======================================================
  static ThemeData get lightTheme {
    return ThemeData(
      // Atur palet warna utama
      primaryColor: kPrimaryColor,
      primarySwatch: Colors.blue, // Ganti ke Colors.blue
      
      // Scaffold global transparan
      scaffoldBackgroundColor: Colors.transparent,
      
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // Tema untuk AppBar
      appBarTheme: const AppBarTheme(
        // Buat AppBar transparan agar menyatu dengan background
        backgroundColor: Colors.transparent, 
        elevation: 0, // Hilangkan bayangan
        foregroundColor: kTextColor,
        iconTheme: IconThemeData(color: kTextColor),
        titleTextStyle: TextStyle(
          color: kTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Tema untuk Tombol (ElevatedButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),

      // Tema untuk Tombol Teks (TextButton)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryColor,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Tema untuk Input Field (TextField)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none, // Tanpa border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor, width: 2.0),
        ),
        labelStyle: const TextStyle(color: kTextLightColor),
        hintStyle: const TextStyle(color: kTextLightColor),
      ),
    );
  }
}