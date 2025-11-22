import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'providers/auth_provider.dart';
import 'providers/search_history_provider.dart';
import 'providers/favorites_provider.dart'; 
import 'screens/main_screen.dart';
import 'theme/app_theme.dart'; 
import 'theme/no_scrollbar_behavior.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()..tryAutoLogin()),
        ChangeNotifierProvider(create: (context) => SearchHistoryProvider()),
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData baseTheme = AppTheme.lightTheme;

    return MaterialApp(
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
      home: const MainScreen(),
    );
  }
}