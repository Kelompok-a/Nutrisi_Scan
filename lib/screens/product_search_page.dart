import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../providers/search_history_provider.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final _searchController = TextEditingController();
  final _productService = ProductService();
  
  List<Product> _searchResults = [];
  bool _isLoading = false; 
  String _errorMessage = ''; 

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
        _errorMessage = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final results = await _productService.searchProducts(query);
      
      setState(() {
        _searchResults = results;
      });

      Provider.of<SearchHistoryProvider>(context, listen: false)
          .addSearchQuery(query);

    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data. Periksa koneksi Anda.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Cari produk (mis: Coca-Cola, Roti)...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                ),
              ),
              onSubmitted: (value) {
                _performSearch(value);
              },
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _buildResultView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)));
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          _searchController.text.isEmpty
              ? 'Masukkan nama produk untuk mencari.'
              : 'Produk tidak ditemukan.',
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            title: Text(product.name),
            subtitle: Text('Kategori: ${product.category}'),
            trailing: Text(
              '${product.sugarPer100g}g Gula',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                  fontSize: 15),
            ),
          ),
        );
      },
    );
  }
}