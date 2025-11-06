import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/produk.dart';
import 'product_detail_page.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final ApiService _apiService = ApiService();
  late Future<List<Produk>> _produkFuture;
  List<Produk> _allProduk = [];
  List<Produk> _filteredProduk = [];
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    super.initState();
    _produkFuture = _apiService.getAllProduk();
    _produkFuture.then((produk) {
      setState(() {
        _allProduk = produk;
        _filteredProduk = produk;
      });
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final keyword = _searchController.text.toLowerCase();
    setState(() {
      if (keyword.isEmpty) {
        _filteredProduk = _allProduk;
      } else {
        _filteredProduk = _allProduk.where((produk) {
          final namaMatch = produk.namaProduk.toLowerCase().contains(keyword);
          final barcodeMatch = produk.barcodeId.toLowerCase().contains(keyword);
          return namaMatch || barcodeMatch;
        }).toList();
      }
    });
  }

  void _navigateToDetail(Produk produk) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(produk: produk),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SearchBar(
              controller: _searchController,
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
              leading: const Icon(Icons.search),
              hintText: 'Ketik nama produk atau barcode...',
              onChanged: (_) => _onSearchChanged(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Produk>>(
                future: _produkFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error memuat data: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada produk di database.'));
                  }

                  // Tampilkan daftar produk yang sudah difilter
                  return ListView.builder(
                    itemCount: _filteredProduk.length,
                    itemBuilder: (context, index) {
                      final produk = _filteredProduk[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12.0),
                          leading: const Icon(Icons.fastfood_outlined, size: 40),
                          title: Text(produk.namaProduk, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Barcode: ${produk.barcodeId}'),
                          onTap: () => _navigateToDetail(produk),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
