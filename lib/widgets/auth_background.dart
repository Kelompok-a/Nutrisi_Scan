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
          // Latar Belakang Gradien Hijau (Pengganti Gambar)
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
          
          // Layout Responsif
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                // Tampilan Web/Desktop (Split-Screen)
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 3,
                          child: SizedBox(), // Sisi kiri kosong, hanya background
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(child: _buildFormCard(context)),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // Tampilan Mobile (Vertikal)
                return Center(
                  child: SingleChildScrollView(
                    child: _buildFormCard(context),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: child, // Di sini form login/register akan ditampilkan
        ),
      ),
    );
  }
}
