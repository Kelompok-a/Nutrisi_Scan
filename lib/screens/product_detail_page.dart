import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/produk.dart';
import '../providers/favorites_provider.dart';

class ProductDetailPage extends StatelessWidget {
  final Produk produk;

  const ProductDetailPage({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(produk.namaProduk),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          // Favorite Button
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              final isFavorite = favoritesProvider.isFavorite(produk.barcodeId);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                tooltip: isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit',
                onPressed: () {
                  favoritesProvider.toggleFavorite(produk);
                  
                  // Show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite 
                          ? '${produk.namaProduk} dihapus dari favorit'
                          : '${produk.namaProduk} ditambahkan ke favorit',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              // LayoutBuilder untuk membuat tampilan responsif
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    // Tampilan untuk layar lebar (web)
                    return _buildWideLayout();
                  } else {
                    // Tampilan untuk layar sempit (mobile)
                    return _buildNarrowLayout();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET UNTUK TAMPILAN LEBAR (2 KOLOM) ---
  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildProductImage(),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 3,
          child: _buildProductInfo(),
        ),
      ],
    );
  }

  // --- WIDGET UNTUK TAMPILAN SEMPIT (1 KOLOM) ---
  Widget _buildNarrowLayout() {
    return Column(
      children: [
        _buildProductImage(),
        const SizedBox(height: 30),
        _buildProductInfo(),
      ],
    );
  }

  // --- BAGIAN-BAGIAN UI YANG BISA DIGUNAKAN KEMBALI ---

  // Widget untuk menampilkan gambar produk
  Widget _buildProductImage() {
    final proxyImageUrl = _buildProxyUrl(produk.imageProductLink);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          color: Colors.grey[200],
          child: proxyImageUrl != null
              ? Image.network(
                  proxyImageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) =>
                      progress == null ? child : const Center(child: CircularProgressIndicator()),
                  errorBuilder: (context, error, stack) =>
                      const Icon(Icons.broken_image_outlined, color: Colors.red, size: 60),
                )
              : const Icon(Icons.hide_image_outlined, color: Colors.grey, size: 60),
        ),
      ),
    );
  }

  // Widget untuk menampilkan semua informasi teks di sisi kanan
  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul dan Kategori
        Text(
          produk.namaKategori ?? 'Produk',
          style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          produk.namaProduk,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, height: 1.2),
        ),
        const SizedBox(height: 24),

        // Sorotan Nutrisi
        _buildNutritionHighlights(),
        const SizedBox(height: 32),

        // Tabel Fakta Nutrisi
        _buildNutritionFactsTable(),
      ],
    );
  }

  // Widget untuk kartu-kartu sorotan nutrisi
  Widget _buildNutritionHighlights() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildHighlightCard('Kalori', produk.totalCalories, 'kcal', Colors.orange),
        _buildHighlightCard('Lemak', produk.totalFat, 'g', Colors.red),
        _buildHighlightCard('Karbohidrat', produk.totalCarbohydrates, 'g', Colors.blue),
        _buildHighlightCard('Protein', produk.protein, 'g', Colors.green),
        _buildHighlightCard('Gula', produk.totalSugar, 'g', Colors.pink),
      ],
    );
  }

  // Widget untuk tabel fakta nutrisi
  Widget _buildNutritionFactsTable() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fakta Nutrisi',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Text('Ukuran Sajian 100g'),
          const Divider(thickness: 2, height: 24),
          _buildFactRow('Lemak Total', '${produk.totalFat.toStringAsFixed(1)}g', ''),
          _buildFactRow('  Lemak Jenuh', '${produk.saturatedFat.toStringAsFixed(1)}g', '${produk.akgSaturatedFat.toStringAsFixed(0)}%'),
          _buildFactRow('Karbohidrat Total', '${produk.totalCarbohydrates.toStringAsFixed(1)}g', '${produk.akgCarbohydrates.toStringAsFixed(0)}%'),
          _buildFactRow('  Gula', '${produk.totalSugar.toStringAsFixed(1)}g', ''),
          _buildFactRow('Protein', '${produk.protein.toStringAsFixed(1)}g', '${produk.akgProtein.toStringAsFixed(0)}%'),
          const Divider(thickness: 1, height: 24),
          const Text('*Persen AKG berdasarkan pada kebutuhan energi 2150 kkal.'),
        ],
      ),
    );
  }

  // --- WIDGET HELPER KECIL ---

  // Helper untuk membuat satu kartu sorotan
  Widget _buildHighlightCard(String label, double value, String unit, Color color) {
    return SizedBox(
      width: 120,
      child: Card(
        elevation: 0,
        color: color.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
              ),
              Text(unit, style: TextStyle(color: color)),
            ],
          ),
        ),
      ),
    );
  }

  // Helper untuk membuat satu baris di tabel fakta nutrisi
  Widget _buildFactRow(String label, String amount, String dailyValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(flex: 5, child: Text(label, style: const TextStyle(fontSize: 16))),
          Expanded(flex: 2, child: Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text(dailyValue, textAlign: TextAlign.right, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  // Helper untuk URL proxy gambar (tidak berubah)
  String? _buildProxyUrl(String? originalUrl) {
    if (originalUrl == null || originalUrl.isEmpty) return null;
    // Asumsi ApiService.baseUrl sudah benar
    return 'http://localhost:3001/api/image-proxy?url=${Uri.encodeComponent(originalUrl)}';
  }
}