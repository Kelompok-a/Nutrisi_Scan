import 'package:flutter/material.dart';
import '../models/produk.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class ProductDetailPage extends StatelessWidget {
  final Produk produk;

  const ProductDetailPage({super.key, required this.produk});

  String? _buildProxyUrl(String? originalUrl) {
    if (originalUrl == null || originalUrl.isEmpty) return null;
    return '${ApiService.baseUrl}/image-proxy?url=${Uri.encodeComponent(originalUrl)}';
  }

  Widget _buildImageFromUrl(String? proxyUrl) {
    if (proxyUrl == null) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.hide_image_outlined, color: Colors.grey, size: 60),
        ),
      );
    }
    return Image.network(
      proxyUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator()),
      errorBuilder: (context, error, stack) => Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.broken_image_outlined, color: Colors.red, size: 60),
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final proxyGambarUrl = _buildProxyUrl(produk.imageProductLink); // Menggunakan imageProductLink
    final proxyBarcodeUrl = _buildProxyUrl(produk.barcodeUrl);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            stretch: true,
            backgroundColor: AppTheme.kPrimaryColor,
            foregroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                produk.namaProduk,
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(left: 48, right: 48, bottom: 16),
              background: _buildImageFromUrl(proxyGambarUrl),
              stretchModes: const [StretchMode.zoomBackground],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.namaProduk,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kategori: ${produk.namaKategori ?? 'N/A'}', // Menggunakan namaKategori
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                  ),
                  const Divider(height: 32, thickness: 1),
                  // Ringkasan Gizi
                  _buildNutritionRow('Kalori', '${produk.totalCalories.toStringAsFixed(1)} kcal', produk.totalCalories / 2000, Colors.orange), // totalCalories
                  _buildNutritionRow('Lemak Total', '${produk.totalFat.toStringAsFixed(1)} g', produk.totalFat / 70, Colors.red), // totalFat
                  _buildNutritionRow('Lemak Jenuh', '${produk.saturatedFat.toStringAsFixed(1)} g', produk.saturatedFat / 20, Colors.redAccent), // saturatedFat
                  _buildNutritionRow('Karbohidrat Total', '${produk.totalCarbohydrates.toStringAsFixed(1)} g', produk.totalCarbohydrates / 300, Colors.blue), // totalCarbohydrates
                  _buildNutritionRow('Gula', '${produk.totalSugar.toStringAsFixed(1)} g', produk.totalSugar / 25, Colors.pink), // totalSugar
                  _buildNutritionRow('Protein', '${produk.protein.toStringAsFixed(1)} g', produk.protein / 50, Colors.green), // protein
                  // Garam/Natrium tidak ada di server.js baru

                  const Divider(height: 32, thickness: 1),
                  Text(
                    'Informasi Nilai Gizi per 100g',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DataTable(
                    columnSpacing: 20,
                    headingRowHeight: 40,
                    dataRowMinHeight: 40,
                    dataRowMaxHeight: 50,
                    columns: const [
                      DataColumn(label: Text('Nama Gizi', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Jumlah', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                      DataColumn(label: Text('% AKG', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                    ],
                    rows: [
                      DataRow(cells: [const DataCell(Text('Kalori')), DataCell(Text(produk.totalCalories.toStringAsFixed(1))), const DataCell(Text('-'))]),
                      DataRow(cells: [const DataCell(Text('Lemak Total')), DataCell(Text(produk.totalFat.toStringAsFixed(1))), const DataCell(Text('-'))]),
                      DataRow(cells: [const DataCell(Text('Lemak Jenuh')), DataCell(Text(produk.saturatedFat.toStringAsFixed(1))), DataCell(Text(produk.akgSaturatedFat.toStringAsFixed(1)))]), // akgSaturatedFat
                      DataRow(cells: [const DataCell(Text('Karbohidrat Total')), DataCell(Text(produk.totalCarbohydrates.toStringAsFixed(1))), DataCell(Text(produk.akgCarbohydrates.toStringAsFixed(1)))]), // akgCarbohydrates
                      DataRow(cells: [const DataCell(Text('Gula')), DataCell(Text(produk.totalSugar.toStringAsFixed(1))), const DataCell(Text('-'))]),
                      DataRow(cells: [const DataCell(Text('Protein')), DataCell(Text(produk.protein.toStringAsFixed(1))), DataCell(Text(produk.akgProtein.toStringAsFixed(1)))]), // akgProtein
                      // Kolesterol, Serat Pangan, Natrium tidak ada di server.js baru
                    ],
                  ),
                  const Divider(height: 32, thickness: 1),
                  Text(
                    'Barcode',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    height: 120,
                    child: _buildImageFromUrl(proxyBarcodeUrl),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
