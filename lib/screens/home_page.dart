import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Kita buat background transparan agar gradien dari main.dart terlihat
      backgroundColor: Colors.transparent,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000), // Batas lebar maks untuk web
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Bagian Header ---
                const Icon(
                  Icons.document_scanner_outlined,
                  size: 80,
                  color: Color(0xFF0056b3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Selamat Datang di NutriScan',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pindai, Kenali, dan Pahami Nutrisi Anda.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black54,
                      ),
                ),
                const SizedBox(height: 40),

                // --- Deskripsi Aplikasi ---
                _buildSectionTitle(context, 'Apa itu NutriScan?'),
                const SizedBox(height: 16),
                const Text(
                  'NutriScan adalah aplikasi web inovatif yang dirancang untuk membantu Anda membuat pilihan makanan yang lebih cerdas dan sehat. Di dunia di mana informasi nutrisi seringkali membingungkan, NutriScan hadir sebagai asisten pribadi Anda. Kami menyediakan data kandungan gizi terperinci dari berbagai produk makanan dan minuman kemasan yang ada di sekitar Anda. Lebih dari sekadar database, fitur andalan kami memungkinkan Anda untuk memindai barcode produk secara langsung dan mendapatkan informasi nutrisinya secara instan.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 40),

                // --- Fitur Unggulan ---
                _buildSectionTitle(context, 'Fitur Unggulan Kami'),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildFeatureCard(
                      icon: Icons.qr_code_scanner_rounded,
                      title: 'Pindai Barcode Instan',
                      description: 'Gunakan kamera perangkat Anda untuk memindai barcode pada kemasan produk dan langsung lihat detail nutrisinya.',
                    ),
                    _buildFeatureCard(
                      icon: Icons.storage_rounded,
                      title: 'Database Lengkap',
                      description: 'Akses informasi dari ribuan produk yang terus kami perbarui untuk memberikan data yang akurat dan relevan.',
                    ),
                    _buildFeatureCard(
                      icon: Icons.pie_chart_outline_rounded,
                      title: 'Detail Nutrisi Terperinci',
                      description: 'Pahami kandungan kalori, lemak, gula, protein, dan lainnya, lengkap dengan persentase Angka Kecukupan Gizi (AKG).',
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // --- Cara Kerja ---
                _buildSectionTitle(context, 'Sangat Mudah Digunakan'),
                const SizedBox(height: 24),
                _buildStep('1', 'Siapkan Produk', 'Ambil produk makanan atau minuman kemasan yang ingin Anda periksa.'),
                const SizedBox(height: 16),
                _buildStep('2', 'Gunakan Fitur Pindai', 'Arahkan kamera ke barcode pada kemasan. Aplikasi akan otomatis mendeteksinya.'),
                const SizedBox(height: 16),
                _buildStep('3', 'Lihat Hasilnya', 'Jika produk terdaftar di database kami, semua informasi nutrisi akan langsung ditampilkan di layar Anda.'),
                const SizedBox(height: 40),

                // --- Penutup ---
                const Text(
                  'Mulai perjalanan Anda menuju gaya hidup yang lebih sehat bersama NutriScan sekarang!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget helper untuk judul setiap bagian
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
    );
  }

  // Widget helper untuk kartu fitur
  Widget _buildFeatureCard({required IconData icon, required String title, required String description}) {
    return SizedBox(
      width: 280,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(icon, size: 48, color: const Color(0xFF0056b3)),
              const SizedBox(height: 16),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(description, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700])),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk langkah-langkah cara kerja
  Widget _buildStep(String number, String title, String description) {
    return Card(
      elevation: 0,
      color: Colors.blue.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF0056b3),
              child: Text(number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(color: Colors.grey[800])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
