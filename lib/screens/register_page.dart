// register_page.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Hapus Stack, Container(Image), dan Container(Overlay)
    return Scaffold(
      // backgroundColor: Colors.transparent, // Tidak perlu, sudah di-handle theme

      // Gunakan AppBar transparan untuk tombol kembali
      appBar: AppBar(
         // backgroundColor: Colors.transparent, // Tidak perlu, sudah di-handle theme
         // elevation: 0, // Tidak perlu, sudah di-handle theme
      ),
      
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Buat Akun Baru',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.kTextColor, // Ganti warna teks
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildTextField(label: 'Nama Pengguna'),
                const SizedBox(height: 20),
                _buildTextField(label: 'Email'),
                const SizedBox(height: 20),
                _buildTextField(label: 'Password', obscureText: true),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  // Tombol ini akan otomatis mengambil style dari ElevatedButtonTheme
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Simulate registration
                    },
                    child: const Text('Daftar'),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  // Teks ini akan otomatis mengambil style dari TextButtonTheme
                  child: const Text('Sudah punya akun? Login di sini'),
                ),
              ],
            ),
          ),
        ),
      ),
      // Hapus Positioned back button
    );
  }

  // Widget ini sekarang akan otomatis mengambil style dari InputDecorationTheme
  Widget _buildTextField({required String label, bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        // Style lain (fillColor, border, etc)
        // otomatis diambil dari AppTheme.lightTheme
      ),
    );
  }
}