import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({
    super.key, 
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // Menggunakan background gradient dari AppTheme agar seragam dengan Home
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          gradient: AppTheme.kBackgroundGradient,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450), // Batas lebar agar rapi di Tablet/Web
              child: Card(
                elevation: 8, // Sedikit bayangan agar pop-up
                shadowColor: AppTheme.kPrimaryColor.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                color: Colors.white, // Kartu Putih Bersih
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}