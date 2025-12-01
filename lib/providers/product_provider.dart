import 'package:flutter/material.dart';
import '../models/produk.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Produk> _allProducts = [];
  List<Produk> _products = []; // Filtered products
  bool _isLoading = false;

  List<Produk> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchAllProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allProducts = await _apiService.getAllProduk();
      // _products = _allProducts; // Uncomment if you want to show all initially
    } catch (e) {
      print('Error fetching products: $e');
      _allProducts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProducts(String query) async {
    if (_allProducts.isEmpty) {
      await fetchAllProducts();
    }

    if (query.isEmpty) {
      _products = [];
      notifyListeners();
      return;
    }

    final lowerQuery = query.toLowerCase();
    _products = _allProducts.where((produk) {
      return produk.namaProduk.toLowerCase().contains(lowerQuery) ||
             produk.barcodeId.toLowerCase().contains(lowerQuery);
    }).toList();
    notifyListeners();
  }
}
