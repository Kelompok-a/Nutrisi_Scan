import 'package:flutter/material.dart';

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
      body: Stack(
        children: [
          // Latar Belakang Gradien Hijau
          Container(
            width: screenSize.width,
            height: screenSize.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade200,
                  Colors.green.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          
          // PERBAIKAN: Menggunakan Center untuk memastikan posisi tengah
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                // PERBAIKAN: Box dibuat lebih besar (extended)
                constraints: const BoxConstraints(maxWidth: 500), 
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Sudut lebih bulat
                    side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
                  ),
                  child: Padding(
                    // Padding di dalam card juga disesuaikan
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
