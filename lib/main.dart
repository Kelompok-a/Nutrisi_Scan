// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; // <-- Import
import 'providers/auth_provider.dart';
import 'providers/search_history_provider.dart';
import 'screens/main_screen.dart';
import 'theme/app_theme.dart'; // <-- Import file theme

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Panggil theme dasar kita
    final ThemeData baseTheme = AppTheme.lightTheme;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => SearchHistoryProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Nutriscan',

        // Terapkan theme DAN font Poppins
        theme: baseTheme.copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme)
              .apply(
                bodyColor: AppTheme.kTextColor, 
                displayColor: AppTheme.kTextColor,
              ),
        ),
        
        // Builder untuk gradasi background global
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              // Ambil gradasi dari file theme
              gradient: AppTheme.kBackgroundGradient,
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: const MainScreen(),
      ),
    );
  }
}