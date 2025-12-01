import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/produk.dart';
import '../providers/search_history_provider.dart';
import 'product_detail_page.dart';
import 'scanner_page.dart';
import '../theme/app_theme.dart';
import '../widgets/footer.dart';

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
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      body: Column(
        children: [
          // --- Search Header ---
          Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            decoration: BoxDecoration(
              color: AppTheme.kSurfaceColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cari Produk',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.kTextColor,
                  ),
                ),
                const SizedBox(height: 16),
                SearchBar(
                  controller: _searchController,
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  backgroundColor: MaterialStatePropertyAll(AppTheme.kBackgroundColor),
                  elevation: const MaterialStatePropertyAll(0),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: AppTheme.kSubTextColor.withOpacity(0.2)),
                    ),
                  ),
                  leading: const Icon(Icons.search, color: AppTheme.kSubTextColor),
                  hintText: 'Ketik nama produk atau barcode...',
                  hintStyle: MaterialStatePropertyAll(
                    TextStyle(color: AppTheme.kSubTextColor.withOpacity(0.7)),
                  ),
                  trailing: [
                    Tooltip(
                      message: 'Scan Barcode',
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.qr_code_scanner_rounded,
                            color: AppTheme.kPrimaryColor,
                          ),
                          onPressed: _openScanner,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (_) => _onSearchChanged(),
                ),
              ],
            ),
          ),

          // --- Product List ---
          Expanded(
            child: FutureBuilder<List<Produk>>(
              future: _produkFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AppTheme.kErrorColor),
                        const SizedBox(height: 16),
                        Text('Error memuat data: ${snapshot.error}'),
                      ],
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada produk di database.'),
                  );
                }

                if (_filteredProduk.isEmpty &&
                    _searchController.text.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 80, color: AppTheme.kSubTextColor.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'Produk tidak ditemukan',
                          style: TextStyle(color: AppTheme.kSubTextColor, fontSize: 18),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: _filteredProduk.length + 1, // +1 for Footer
                  itemBuilder: (context, index) {
                    if (index == _filteredProduk.length) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 48.0),
                        child: Footer(),
                      );
                    }

                    final produk = _filteredProduk[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppTheme.kSurfaceColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.kPrimaryColor.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _navigateToDetail(produk),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: AppTheme.kPrimaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.fastfood_rounded,
                                    color: AppTheme.kPrimaryColor,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        produk.namaProduk,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.kTextColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppTheme.kSubTextColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'Barcode: ${produk.barcodeId}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.kSubTextColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded, color: AppTheme.kSubTextColor),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
