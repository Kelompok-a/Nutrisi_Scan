import 'dart:convert';

List<Produk> produkListFromJson(String str) =>
    List<Produk>.from(json.decode(str).map((x) => Produk.fromJson(x)));

class Produk {
  final String barcodeId;
  final String namaProduk;
  final double? ukuranNilai;
  final String? ukuranSatuan;
  final String? barcodeUrl;
  final String? imageProductLink;
  final String? namaKategori;
  
  // Data Gizi yang tersedia dari server.js
  final double totalCalories;
  final double totalFat;
  final double saturatedFat;
  final double totalSugar;
  final double protein;
  final double akgProtein;
  final double totalCarbohydrates;
  final double akgCarbohydrates;
  final double akgSaturatedFat;

  Produk({
    required this.barcodeId,
    required this.namaProduk,
    this.ukuranNilai,
    this.ukuranSatuan,
    this.barcodeUrl,
    this.imageProductLink,
    this.namaKategori,
    required this.totalCalories,
    required this.totalFat,
    required this.saturatedFat,
    required this.totalSugar,
    required this.protein,
    required this.akgProtein,
    required this.totalCarbohydrates,
    required this.akgCarbohydrates,
    required this.akgSaturatedFat,
  });

  static double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static String _parseToString(dynamic value) {
    return value?.toString() ?? 'N/A';
  }

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      barcodeId: _parseToString(json['barcode_id']),
      namaProduk: _parseToString(json['product_name']), // Changed from nama_produk
      ukuranNilai: _parseToDouble(json['ukuran_nilai']),
      ukuranSatuan: json['ukuran_satuan'],
      barcodeUrl: json['barcodeUrl'], // Changed from barcode_url
      imageProductLink: json['gambarUrl'], // Changed from image_product_link
      namaKategori: json['kategori'], // Changed from nama_kategori
      totalCalories: _parseToDouble(json['energi']), // Changed from total_calories
      totalFat: _parseToDouble(json['lemak']), // Changed from total_fat
      saturatedFat: _parseToDouble(json['lemak_jenuh']), // Changed from saturated_fat
      totalSugar: _parseToDouble(json['gula']), // Changed from total_sugar
      protein: _parseToDouble(json['protein']),
      akgProtein: _parseToDouble(json['akg_protein']), // Note: These might be missing in backend query
      totalCarbohydrates: _parseToDouble(json['karbohidrat']), // Changed from total_carbohydrates
      akgCarbohydrates: _parseToDouble(json['akg_carbohydrates']), // Note: These might be missing
      akgSaturatedFat: _parseToDouble(json['akg_saturated_fat']), // Note: These might be missing
    );
  }
}
