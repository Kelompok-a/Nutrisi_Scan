import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Header Section ---
                Card(
                  elevation: 4,
                  shadowColor: theme.primaryColor.withOpacity(0.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    padding: const EdgeInsets.all(32.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [theme.primaryColor.withOpacity(0.3), Colors.black.withOpacity(0.3)]
                            : [theme.primaryColor.withOpacity(0.1), Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.document_scanner_outlined,
                          size: 80,
                          color: theme.primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Selamat Datang di NutriScan',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pindai, Kenali, dan Pahami Nutrisi Anda.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // --- Deskripsi Aplikasi ---
                _buildSectionTitle(context, 'Apa itu NutriScan?'),
                const SizedBox(height: 16),
                Text(
                  'NutriScan adalah aplikasi web inovatif yang dirancang untuk membantu Anda membuat pilihan makanan yang lebih cerdas dan sehat. Di dunia di mana informasi nutrisi seringkali membingungkan, NutriScan hadir sebagai asisten pribadi Anda. Kami menyediakan data kandungan gizi terperinci dari berbagai produk makanan dan minuman kemasan yang ada di sekitar Anda. Lebih dari sekadar database, fitur andalan kami memungkinkan Anda untuk memindai barcode produk secara langsung dan mendapatkan informasi nutrisinya secara instan.',
                  textAlign: TextAlign.justify,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                ),
                const SizedBox(height: 48),

                // --- Fitur Unggulan ---
                _buildSectionTitle(context, 'Fitur Unggulan Kami'),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildFeatureCard(
                      context: context,
                      icon: Icons.qr_code_scanner_rounded,
                      title: 'Pindai Barcode Instan',
                      description: 'Gunakan kamera perangkat Anda untuk memindai barcode pada kemasan produk dan langsung lihat detail nutrisinya.',
                    ),
                    _buildFeatureCard(
                      context: context,
                      icon: Icons.storage_rounded,
                      title: 'Database Lengkap',
                      description: 'Akses informasi dari ribuan produk yang terus kami perbarui untuk memberikan data yang akurat dan relevan.',
                    ),
                    _buildFeatureCard(
                      context: context,
                      icon: Icons.pie_chart_outline_rounded,
                      title: 'Detail Nutrisi Terperinci',
                      description: 'Pahami kandungan kalori, lemak, gula, protein, dan lainnya, lengkap dengan persentase Angka Kecukupan Gizi (AKG).',
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // --- Cara Kerja ---
                _buildSectionTitle(context, 'Sangat Mudah Digunakan'),
                const SizedBox(height: 24),
                _buildStep(context, '1', 'Siapkan Produk', 'Ambil produk makanan atau minuman kemasan yang ingin Anda periksa.'),
                const SizedBox(height: 16),
                _buildStep(context, '2', 'Gunakan Fitur Pindai', 'Arahkan kamera ke barcode pada kemasan. Aplikasi akan otomatis mendeteksinya.'),
                const SizedBox(height: 16),
                _buildStep(context, '3', 'Lihat Hasilnya', 'Jika produk terdaftar, semua informasi nutrisi akan langsung ditampilkan di layar Anda.'),
                const SizedBox(height: 48),

                // --- Penutup ---
                Text(
                  'Mulai perjalanan Anda menuju gaya hidup yang lebih sehat bersama NutriScan sekarang!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({required BuildContext context, required IconData icon, required String title, required String description}) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 280,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.primaryColor.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(icon, size: 48, color: theme.primaryColor),
              const SizedBox(height: 16),
              Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(description, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, String number, String title, String description) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.primaryColor.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.primaryColor.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: theme.primaryColor,
              child: Text(number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
