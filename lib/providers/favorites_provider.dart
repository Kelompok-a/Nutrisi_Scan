import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/produk.dart';

class FavoritesProvider with ChangeNotifier {
  List<Produk> _favorites = [];

  List<Produk> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  // Load favorites dari SharedPreferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString('favorites');
    
    if (favoritesJson != null) {
      final List<dynamic> decoded = jsonDecode(favoritesJson);
      _favorites = decoded.map((item) => Produk.fromJson(item)).toList();
      notifyListeners();
    }
  }

  // Save favorites ke SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = jsonEncode(
      _favorites.map((produk) => _produkToJson(produk)).toList(),
    );
    await prefs.setString('favorites', favoritesJson);
  }

  // Convert Produk to JSON
  Map<String, dynamic> _produkToJson(Produk produk) {
    return {
      'barcode_id': produk.barcodeId,
      'nama_produk': produk.namaProduk,
      'ukuran_nilai': produk.ukuranNilai,
      'ukuran_satuan': produk.ukuranSatuan,
      'barcode_url': produk.barcodeUrl,
      'image_product_link': produk.imageProductLink,
      'nama_kategori': produk.namaKategori,
      'total_calories': produk.totalCalories,
      'total_fat': produk.totalFat,
      'saturated_fat': produk.saturatedFat,
      'total_sugar': produk.totalSugar,
      'protein': produk.protein,
      'akg_protein': produk.akgProtein,
      'total_carbohydrates': produk.totalCarbohydrates,
      'akg_carbohydrates': produk.akgCarbohydrates,
      'akg_saturated_fat': produk.akgSaturatedFat,
    };
  }

  // Cek apakah produk sudah di-favorite
  bool isFavorite(String barcodeId) {
    return _favorites.any((produk) => produk.barcodeId == barcodeId);
  }

  // Toggle favorite (add/remove)
  Future<void> toggleFavorite(Produk produk) async {
    if (isFavorite(produk.barcodeId)) {
      _favorites.removeWhere((p) => p.barcodeId == produk.barcodeId);
    } else {
      _favorites.add(produk);
    }
    
    await _saveFavorites();
    notifyListeners();
  }

  // Hapus produk dari favorites
  Future<void> removeFavorite(String barcodeId) async {
    _favorites.removeWhere((p) => p.barcodeId == barcodeId);
    await _saveFavorites();
    notifyListeners();
  }

  // Hapus semua favorites
  Future<void> clearFavorites() async {
    _favorites.clear();
    await _saveFavorites();
    notifyListeners();
  }

  // Get total favorites count
  int get favoritesCount => _favorites.length;
}