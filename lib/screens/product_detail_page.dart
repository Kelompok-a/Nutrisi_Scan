import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/produk.dart';
import '../providers/favorites_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/footer.dart';
import 'login_page.dart';

class ProductDetailPage extends StatelessWidget {
  final Produk produk;

  const ProductDetailPage({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      appBar: AppBar(
        title: Text(
          produk.namaProduk,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.kSurfaceColor,
        elevation: 0,
        foregroundColor: AppTheme.kTextColor,
        actions: [
          // Favorite Button
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              final isFavorite = favoritesProvider.isFavorite(produk.barcodeId);
              return Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: isFavorite ? AppTheme.kErrorColor.withOpacity(0.1) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isFavorite ? AppTheme.kErrorColor : AppTheme.kSubTextColor,
                  ),
                  tooltip: isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit',
                  onPressed: () {
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  // LayoutBuilder untuk membuat tampilan responsif
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 800) {
                        // Tampilan untuk layar lebar (web)
                        return _buildWideLayout(context);
                      } else {
                        // Tampilan untuk layar sempit (mobile)
                        return _buildNarrowLayout(context);
                      }
                    },
                  ),
                ),
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }

  // --- WIDGET UNTUK TAMPILAN LEBAR (2 KOLOM) ---
  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildProductImage(),
        ),
        const SizedBox(width: 48),
        Expanded(
          flex: 3,
          child: _buildProductInfo(context),
        ),
      ],
    );
  }

  // --- WIDGET UNTUK TAMPILAN SEMPIT (1 KOLOM) ---
  Widget _buildNarrowLayout(BuildContext context) {
    return Column(
      children: [
        _buildProductImage(),
        const SizedBox(height: 32),
        _buildProductInfo(context),
      ],
    );
  }

  // --- BAGIAN-BAGIAN UI YANG BISA DIGUNAKAN KEMBALI ---

  // Widget untuk menampilkan gambar produk
  Widget _buildProductImage() {
    final proxyImageUrl = _buildProxyUrl(produk.imageProductLink);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.kPrimaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            color: Colors.grey[50],
            child: proxyImageUrl != null
                ? Image.network(
                    proxyImageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) =>
                        progress == null ? child : const Center(child: CircularProgressIndicator()),
                    errorBuilder: (context, error, stack) =>
                        Icon(Icons.broken_image_rounded, color: AppTheme.kErrorColor.withOpacity(0.5), size: 60),
                  )
                : Icon(Icons.hide_image_rounded, color: AppTheme.kSubTextColor.withOpacity(0.5), size: 60),
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan semua informasi teks di sisi kanan
  Widget _buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul dan Kategori
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.kSecondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            produk.namaKategori ?? 'Produk',
            style: TextStyle(color: AppTheme.kSecondaryColor, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          produk.namaProduk,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.kTextColor,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 32),

        // Sorotan Nutrisi
        _buildNutritionHighlights(),
        const SizedBox(height: 40),

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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.kSurfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.kPrimaryColor.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: AppTheme.kPrimaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: AppTheme.kPrimaryColor),
              const SizedBox(width: 12),
              const Text(
                'Fakta Nutrisi',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.kTextColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Ukuran Sajian 100g', style: TextStyle(color: AppTheme.kSubTextColor)),
          const Divider(thickness: 1, height: 32),
          _buildFactRow('Lemak Total', '${produk.totalFat.toStringAsFixed(1)}g', ''),
          _buildFactRow('  Lemak Jenuh', '${produk.saturatedFat.toStringAsFixed(1)}g', '${produk.akgSaturatedFat.toStringAsFixed(0)}%'),
          _buildFactRow('Karbohidrat Total', '${produk.totalCarbohydrates.toStringAsFixed(1)}g', '${produk.akgCarbohydrates.toStringAsFixed(0)}%'),
          _buildFactRow('  Gula', '${produk.totalSugar.toStringAsFixed(1)}g', ''),
          _buildFactRow('Protein', '${produk.protein.toStringAsFixed(1)}g', '${produk.akgProtein.toStringAsFixed(0)}%'),
          const Divider(thickness: 1, height: 32),
          Text(
            '*Persen AKG berdasarkan pada kebutuhan energi 2150 kkal.',
            style: TextStyle(fontSize: 12, color: AppTheme.kSubTextColor, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER KECIL ---

  // Helper untuk membuat satu kartu sorotan
  Widget _buildHighlightCard(String label, double value, String unit, Color color) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            value.toStringAsFixed(1),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            unit,
            style: TextStyle(color: color.withOpacity(0.8), fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Helper untuk membuat satu baris di tabel fakta nutrisi
  Widget _buildFactRow(String label, String amount, String dailyValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.kTextColor,
                fontWeight: label.startsWith('  ') ? FontWeight.normal : FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              amount,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.kTextColor),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              dailyValue,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk URL proxy gambar
  String? _buildProxyUrl(String? originalUrl) {
    if (originalUrl == null || originalUrl.isEmpty) return null;
    // Asumsi ApiService.baseUrl sudah benar
    return 'http://localhost:3001/api/image-proxy?url=${Uri.encodeComponent(originalUrl)}';
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(
                color: Color(0xFFE53935), // Red color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Whoops!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 32),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    'Anda harus login terlebih dahulu untuk menggunakan fitur ini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}