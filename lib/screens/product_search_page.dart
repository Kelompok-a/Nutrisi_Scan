import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/produk.dart';
import '../providers/search_history_provider.dart';
import 'product_detail_page.dart';
import 'scanner_page.dart';
import '../theme/app_theme.dart'; // Import theme untuk warna

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
  String _lastSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _produkFuture = _apiService.getAllProduk();
    _produkFuture.then((produk) {
      if (mounted) {
        setState(() {
          _allProduk = produk;
          _filteredProduk = produk;
        });
      }
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

    if (keyword.isNotEmpty && keyword != _lastSearchQuery) {
      _lastSearchQuery = keyword;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        if (keyword == _searchController.text.toLowerCase() &&
            keyword.isNotEmpty) {
          final historyProvider = Provider.of<SearchHistoryProvider>(
            context,
            listen: false,
          );
          historyProvider.addSearchQuery(keyword);
        }
      });
    }
  }

  void _navigateToDetail(Produk produk) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(produk: produk),
      ),
    );
  }

  void _openScanner() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ScannerPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- PERUBAHAN DI SINI ---
            // Scanner dimasukkan ke dalam SearchBar (seperti Google Lens)
            SearchBar(
              controller: _searchController,
              // Jarak padding dalam
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
              // Ikon Kaca Pembesar di Kiri
              leading: const Icon(Icons.search, color: Colors.grey),

              // Placeholder Text
              hintText: 'Ketik nama produk atau barcode...',

              // Ikon Scanner di Kanan (Trailing)
              trailing: [
                Tooltip(
                  message: 'Scan Barcode',
                  child: IconButton(
                    // Ikon Scanner berwarna Biru (sesuai tema)
                    icon: const Icon(
                      Icons.qr_code_scanner,
                      color: AppTheme.kPrimaryColor,
                    ),
                    onPressed: _openScanner,
                  ),
                ),
              ],

              onChanged: (_) => _onSearchChanged(),
            ),

            // -------------------------
            const SizedBox(height: 16),

            Expanded(
              child: FutureBuilder<List<Produk>>(
                future: _produkFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error memuat data: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada produk di database.'),
                    );
                  }

                  if (_filteredProduk.isEmpty &&
                      _searchController.text.isNotEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 60, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Produk tidak ditemukan',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: _filteredProduk.length,
                    itemBuilder: (context, index) {
                      final produk = _filteredProduk[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12.0),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade50,
                            child: const Icon(
                              Icons.fastfood_outlined,
                              color: AppTheme.kPrimaryColor,
                            ),
                          ),
                          title: Text(
                            produk.namaProduk,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
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
