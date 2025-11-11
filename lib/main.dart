import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'providers/auth_provider.dart';
import 'providers/search_history_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart'; 
import 'theme/no_scrollbar_behavior.dart'; // Import aturan baru

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData baseTheme = AppTheme.lightTheme;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => SearchHistoryProvider()),
      ],
      child: MaterialApp(
        // PERBAIKAN: Terapkan aturan untuk menyembunyikan scrollbar
        scrollBehavior: NoScrollbarBehavior(), 
        debugShowCheckedModeBanner: false,
        title: 'Nutriscan',

        theme: baseTheme.copyWith(
          textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme)
              .apply(
                bodyColor: AppTheme.kTextColor, 
                displayColor: AppTheme.kTextColor,
              ),
        ),
        
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.kBackgroundGradient,
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: const SplashScreen(),
      ),
    );
  }
}
