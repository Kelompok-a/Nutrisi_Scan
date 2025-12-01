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
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // --- Search Header ---
          Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            decoration: BoxDecoration(
              color: theme.cardColor,
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
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),
                SearchBar(
                  controller: _searchController,
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  backgroundColor: MaterialStatePropertyAll(theme.scaffoldBackgroundColor),
                  elevation: const MaterialStatePropertyAll(0),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
                    ),
                  ),
                  leading: Icon(Icons.search, color: theme.iconTheme.color?.withOpacity(0.7)),
                  hintText: 'Ketik nama produk atau barcode...',
                  hintStyle: MaterialStatePropertyAll(
                    TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
                  ),
                  trailing: [
                    Tooltip(
                      message: 'Scan Barcode',
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.qr_code_scanner_rounded,
                            color: theme.primaryColor,
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
                        Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
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
                        Icon(Icons.search_off_rounded, size: 80, color: theme.disabledColor.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text(
                          'Produk tidak ditemukan',
                          style: TextStyle(color: theme.disabledColor, fontSize: 18),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _filteredProduk.length,
                  itemBuilder: (context, index) {
                    final produk = _filteredProduk[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.05),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 3,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  child: produk.imageProductLink != null && produk.imageProductLink!.isNotEmpty
                                      ? Image.network(
                                          'http://localhost:3001/api/image-proxy?url=${Uri.encodeComponent(produk.imageProductLink!)}',
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            color: theme.primaryColor.withOpacity(0.1),
                                            child: Icon(
                                              Icons.broken_image_rounded,
                                              color: theme.primaryColor.withOpacity(0.5),
                                              size: 40,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          color: theme.primaryColor.withOpacity(0.1),
                                          child: Icon(
                                            Icons.fastfood_rounded,
                                            color: theme.primaryColor,
                                            size: 40,
                                          ),
                                        ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            produk.namaProduk,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            produk.namaKategori ?? 'Umum',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${produk.totalCalories.toStringAsFixed(0)} kcal',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: theme.primaryColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: theme.primaryColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
