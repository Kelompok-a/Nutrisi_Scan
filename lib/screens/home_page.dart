// home_page.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart'; // <-- Import theme

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Hapus Stack, Container, dan Overlay.
    // Langsung gunakan Scaffold dengan background transparan
    return Scaffold(
      // backgroundColor: Colors.transparent, // Tidak perlu, sudah di-handle theme
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Selamat Datang di SugarChecker',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.kTextColor, // Ganti warna teks
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Silakan gunakan navigasi di atas untuk mencari produk, membaca artikel, atau melihat riwayat pencarian Anda.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.kTextLightColor, // Ganti warna teks
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}