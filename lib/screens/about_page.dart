import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),

            // --- HEADER: VERSI ---
            const SizedBox(height: 16),
            const Text(
              'NutriScan',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Text(
              'Versi 1.0.0',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // --- DESKRIPSI APLIKASI (Disesuaikan dengan Poin 1 Kesimpulan) ---
            const Text(
              'Tentang Aplikasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'NutriScan dikembangkan untuk membantu masyarakat mengetahui kadar gula pada produk makanan dan minuman kemasan secara cepat, akurat, dan mudah dipahami. Melalui teknologi pemindaian barcode, kami berupaya meningkatkan kesadaran konsumen terhadap konsumsi gula harian demi mewujudkan pola hidup yang lebih sehat.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            // --- FITUR UTAMA (Disesuaikan dengan Poin 4 Kesimpulan) ---
            Card(
              elevation: 2,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    _buildFeatureItem(
                      Icons.qr_code_scanner,
                      'Scan Barcode Cepat',
                      'Identifikasi produk & gula dalam hitungan detik.',
                    ),
                    const Divider(indent: 20, endIndent: 20),
                    _buildFeatureItem(
                      Icons.search,
                      'Pencarian Manual',
                      'Cari data produk jika barcode tidak tersedia.',
                    ),
                    const Divider(indent: 20, endIndent: 20),
                    _buildFeatureItem(
                      Icons
                          .insights, // Ikon diganti agar lebih relevan dengan "Mudah Dipahami"
                      'Informasi Gizi Jelas',
                      'Tampilan visual gizi yang simpel dan responsif.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- DISCLAIMER ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade800,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Disclaimer: Data nutrisi disajikan sebagai panduan edukasi. Untuk saran kesehatan spesifik terkait diabetes atau kondisi medis lainnya, harap konsultasikan dengan dokter.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- FOOTER ---
            Text(
              'Dikembangkan oleh Kelompok 2',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.kPrimaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '© 2025 NutriScan.id',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.kPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.kPrimaryColor, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      ),
    );
  }
}
