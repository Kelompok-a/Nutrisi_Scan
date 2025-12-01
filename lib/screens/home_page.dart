import 'package:flutter/material.dart';
import '../widgets/footer.dart';
import '../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Content Section ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- Hero Section ---
                    Container(
                      padding: const EdgeInsets.all(48.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.kPrimaryColor,
                            AppTheme.kSecondaryColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.kPrimaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.health_and_safety_rounded,
                            size: 80,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Selamat Datang di NutriScan',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Pindai, Kenali, dan Pahami Nutrisi Anda.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 64),

                    // --- Deskripsi Aplikasi ---
                    _buildSectionTitle(context, 'Apa itu NutriScan?'),
                    const SizedBox(height: 24),
                    Text(
                      'NutriScan adalah asisten kesehatan pribadi Anda. Kami membantu Anda membuat keputusan yang lebih cerdas tentang makanan yang Anda konsumsi. Dengan teknologi pemindaian barcode canggih dan database nutrisi yang komprehensif, Anda dapat mengetahui apa yang sebenarnya ada di dalam makanan Anda dalam hitungan detik.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.8,
                        fontSize: 18,
                        color: AppTheme.kSubTextColor,
                      ),
                    ),
                    const SizedBox(height: 64),

                    // --- Fitur Unggulan ---
                    _buildSectionTitle(context, 'Fitur Unggulan'),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildFeatureCard(
                          context: context,
                          icon: Icons.qr_code_scanner_rounded,
                          title: 'Scan Instan',
                          description: 'Pindai barcode produk untuk info nutrisi seketika.',
                        ),
                        _buildFeatureCard(
                          context: context,
                          icon: Icons.analytics_rounded,
                          title: 'Analisis Nutrisi',
                          description: 'Pahami kandungan gula, lemak, dan kalori dengan mudah.',
                        ),
                        _buildFeatureCard(
                          context: context,
                          icon: Icons.history_rounded,
                          title: 'Riwayat & Favorit',
                          description: 'Simpan produk favorit dan pantau riwayat pencarian Anda.',
                        ),
                      ],
                    ),
                    const SizedBox(height: 64),

                    // --- Cara Kerja ---
                    _buildSectionTitle(context, 'Cara Kerja'),
                    const SizedBox(height: 32),
                    _buildStep(context, '1', 'Ambil Produk', 'Siapkan makanan kemasan yang ingin dicek.'),
                    const SizedBox(height: 16),
                    _buildStep(context, '2', 'Scan Barcode', 'Gunakan kamera untuk memindai kode batang.'),
                    const SizedBox(height: 16),
                    _buildStep(context, '3', 'Lihat Hasil', 'Dapatkan info nutrisi lengkap dalam sekejap.'),
                    const SizedBox(height: 64),

                    // --- Call to Action ---
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
                      decoration: BoxDecoration(
                        color: AppTheme.kSurfaceColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppTheme.kPrimaryColor.withOpacity(0.1)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Siap untuk Hidup Lebih Sehat?',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.kTextColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Bergabunglah dengan ribuan pengguna lain yang telah beralih ke gaya hidup yang lebih sadar nutrisi.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppTheme.kSubTextColor, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // --- Footer ---
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.kTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: AppTheme.kPrimaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({required BuildContext context, required IconData icon, required String title, required String description}) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.kSurfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.kPrimaryColor.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.kPrimaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: AppTheme.kPrimaryColor),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.kTextColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.kSubTextColor,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context, String number, String title, String description) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.kPrimaryColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.kPrimaryColor.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.kTextColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: AppTheme.kSubTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
