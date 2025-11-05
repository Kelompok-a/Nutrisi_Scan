import 'package:flutter/material.dart';
import '../models/produk.dart';
import '../models/komposisi_gizi.dart';
import '../theme/app_theme.dart';

class ProductDetailPage extends StatelessWidget {
  final Produk produk;
  final KomposisiGizi komposisi;

  const ProductDetailPage({super.key, required this.produk, required this.komposisi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(produk.namaProduk),
        backgroundColor: AppTheme.kPrimaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
      ),
      body: ListView(
        // Menggunakan ListView agar bisa scroll jika kontennya panjang
        children: [
          // --- Bagian Gambar Produk ---
          Container(
            color: Colors.white, // Latar belakang putih untuk gambar
            padding: const EdgeInsets.all(24.0),
            height: 250, // Tinggi area gambar
            child: (produk.gambarUrl != null && produk.gambarUrl!.isNotEmpty)
                ? Image.network(
                    produk.gambarUrl!,
                    fit: BoxFit.contain, // Agar gambar tidak terpotong
                    // Menampilkan loading indicator saat gambar sedang diunduh
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    // Menampilkan ikon jika gambar gagal dimuat
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return const Icon(Icons.image_not_supported, color: Colors.grey, size: 60);
                    },
                  )
                : const Icon(Icons.image_not_supported, color: Colors.grey, size: 60), // Tampilan jika URL null
          ),
          
          // --- Bagian Informasi Produk dan Gizi ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produk.namaProduk,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.kTextColor,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kategori: ${produk.kategori}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.kTextLightColor,
                      ),
                ),
                const Divider(height: 32, thickness: 1),

                // --- Grid Informasi Gizi ---
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildNutritionCard(
                      context: context,
                      icon: Icons.local_fire_department,
                      label: 'Energi',
                      value: '${komposisi.energi.toStringAsFixed(1)} kcal',
                      color: Colors.orange,
                      progress: komposisi.energi / 2000,
                    ),
                    _buildNutritionCard(
                      context: context,
                      icon: Icons.fastfood,
                      label: 'Lemak',
                      value: '${komposisi.lemak.toStringAsFixed(1)} g',
                      color: Colors.red,
                      progress: komposisi.lemak / 70,
                    ),
                    _buildNutritionCard(
                      context: context,
                      icon: Icons.egg,
                      label: 'Protein',
                      value: '${komposisi.protein.toStringAsFixed(1)} g',
                      color: Colors.green,
                      progress: komposisi.protein / 50,
                    ),
                    _buildNutritionCard(
                      context: context,
                      icon: Icons.bakery_dining,
                      label: 'Karbohidrat',
                      value: '${komposisi.karbohidrat.toStringAsFixed(1)} g',
                      color: Colors.blue,
                      progress: komposisi.karbohidrat / 300,
                    ),
                    _buildNutritionCard(
                      context: context,
                      icon: Icons.cake,
                      label: 'Gula',
                      value: '${komposisi.gula.toStringAsFixed(1)} g',
                      color: Colors.pink,
                      progress: komposisi.gula / 25,
                    ),
                    _buildNutritionCard(
                      context: context,
                      icon: Icons.grain,
                      label: 'Garam',
                      value: '${komposisi.garam.toStringAsFixed(1)} g',
                      color: Colors.grey,
                      progress: komposisi.garam / 6,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required double progress,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 30),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    strokeWidth: 5,
                    backgroundColor: color.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.kTextLightColor,
                  ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.kTextColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
