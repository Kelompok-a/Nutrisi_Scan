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

  String get barcode => barcodeId;
  String? get gambarUrl => imageProductLink;

  Map<String, dynamic> toJson() {
    return {
      'barcode_id': barcodeId,
      'product_name': namaProduk,
      'ukuran_nilai': ukuranNilai,
      'ukuran_satuan': ukuranSatuan,
      'barcodeUrl': barcodeUrl,
      'gambarUrl': imageProductLink,
      'kategori': namaKategori,
      'energi': totalCalories,
      'lemak': totalFat,
      'lemak_jenuh': saturatedFat,
      'gula': totalSugar,
      'protein': protein,
      'akg_protein': akgProtein,
      'karbohidrat': totalCarbohydrates,
      'akg_carbohydrates': akgCarbohydrates,
      'akg_saturated_fat': akgSaturatedFat,
    };
  }

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      barcodeId: _parseToString(json['barcode_id']),
      namaProduk: _parseToString(json['product_name']),
      ukuranNilai: _parseToDouble(json['ukuran_nilai']),
      ukuranSatuan: json['ukuran_satuan'],
      barcodeUrl: json['barcodeUrl'],
      imageProductLink: json['gambarUrl'],
      namaKategori: json['kategori'],
      totalCalories: _parseToDouble(json['energi']),
      totalFat: _parseToDouble(json['lemak']),
      saturatedFat: _parseToDouble(json['lemak_jenuh']),
      totalSugar: _parseToDouble(json['gula']),
      protein: _parseToDouble(json['protein']),
      akgProtein: _parseToDouble(json['akg_protein']),
      totalCarbohydrates: _parseToDouble(json['karbohidrat']),
      akgCarbohydrates: _parseToDouble(json['akg_carbohydrates']),
      akgSaturatedFat: _parseToDouble(json['akg_saturated_fat']),
    );
  }
}
