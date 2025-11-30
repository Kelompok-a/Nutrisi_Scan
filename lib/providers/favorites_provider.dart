import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/produk.dart';

class FavoritesProvider with ChangeNotifier {
  List<Produk> _favorites = [];
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = 'http://localhost:3001'; // Sesuaikan dengan URL server

  List<Produk> get favorites => _favorites;

  FavoritesProvider() {
    fetchFavorites();
  }

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Fetch favorites from API
  Future<void> fetchFavorites() async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/favorites'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true) {
          final List<dynamic> data = body['data'];
          _favorites = data.map((item) {
            // Map API response to Produk model
            return Produk(
              barcodeId: item['barcode_id'].toString(),
              namaProduk: item['product_name'],
              ukuranNilai: 0, // Default or from API if available
              ukuranSatuan: '',
              barcodeUrl: item['barcodeUrl'],
              imageProductLink: item['gambarUrl'],
              namaKategori: 'Favorit',
              totalCalories: (item['energi'] ?? 0).toDouble(),
              totalFat: (item['lemak'] ?? 0).toDouble(),
              saturatedFat: (item['lemak_jenuh'] ?? 0).toDouble(),
              totalSugar: (item['gula'] ?? 0).toDouble(),
              protein: (item['protein'] ?? 0).toDouble(),
              akgProtein: 0,
              totalCarbohydrates: (item['karbohidrat'] ?? 0).toDouble(),
              akgCarbohydrates: 0,
              akgSaturatedFat: 0,
            );
          }).toList();
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  // Cek status favorit dari API
  Future<bool> checkFavoriteStatus(String barcodeId) async {
    final token = await _getToken();
    if (token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/favorites/check/$barcodeId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['isFavorite'] == true;
      }
    } catch (e) {
      print('Error checking favorite: $e');
    }
    return false;
  }

  // Toggle favorite (add/remove)
  Future<void> toggleFavorite(Produk produk) async {
    final token = await _getToken();
    if (token == null) return;

    final isFav = isFavorite(produk.barcodeId);

    try {
      if (isFav) {
        // Remove
        final response = await http.delete(
          Uri.parse('$_baseUrl/api/favorites/${produk.barcodeId}'),
          headers: {'Authorization': 'Bearer $token'},
        );
        if (response.statusCode == 200) {
          _favorites.removeWhere((p) => p.barcodeId == produk.barcodeId);
        }
      } else {
        // Add
        final response = await http.post(
          Uri.parse('$_baseUrl/api/favorites'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'barcodeId': produk.barcodeId}),
        );
        if (response.statusCode == 200) {
          _favorites.add(produk);
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  // Hapus produk dari favorites (Explicit remove)
  Future<void> removeFavorite(String barcodeId) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/favorites/$barcodeId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        _favorites.removeWhere((p) => p.barcodeId == barcodeId);
        notifyListeners();
      }
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  // Helper untuk cek lokal (untuk UI update instan)
  bool isFavorite(String barcodeId) {
    return _favorites.any((produk) => produk.barcodeId == barcodeId);
  }

  // Hapus semua favorites (looping delete API)
  Future<void> clearFavorites() async {
    final token = await _getToken();
    if (token == null) return;

    // Note: Idealnya ada endpoint DELETE /api/favorites/all
    // Untuk sekarang kita clear list lokal dulu
    _favorites.clear();
    notifyListeners();
    
    // TODO: Implement clear all API if needed
  }

  int get favoritesCount => _favorites.length;
}