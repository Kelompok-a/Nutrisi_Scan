import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // --- WARNA SAYA KEMBALIKAN KE BIRU (Sesuai gambar Login) ---
  static const Color kPrimaryColor = Color(0xFF0056b3); // Biru Utama
  static const Color kSecondaryColor = Color(0xFF007BFF); // Biru Terang
  static const Color kBackgroundColor = Color(0xFFF0F4F8); // Putih Kebiruan (Background)
  static const Color kTextColor = Color(0xFF212121); // Hitam untuk teks
  static const Color kErrorColor = Color(0xFFD32F2F);

  // Gradien Background (Biru Muda Halus)
  static const LinearGradient kBackgroundGradient = LinearGradient(
    colors: [Color(0xFFE3F2FD), Color(0xFFF8FBFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kBackgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimaryColor,
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      background: kBackgroundColor,
      error: kErrorColor,
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white, // AppBar Putih
      elevation: 1, // Ada bayangan sedikit
      centerTitle: false,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    cardTheme: CardThemeData(
      elevation: 2,
      shadowColor: Colors.black12,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    // --- INPUT FIELD DENGAN GARIS (Sesuai request sebelumnya) ---
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kPrimaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kErrorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kErrorColor, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.grey.shade600),
      prefixIconColor: kPrimaryColor,
    ),
  );
}