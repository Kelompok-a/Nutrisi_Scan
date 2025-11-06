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

  @override
  void initState() {
    super.initState();
    _produkFuture = _apiService.getAllProduk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Produk'),
      ),
      body: FutureBuilder<List<Produk>>(
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

          _allProduk = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onTap: () => controller.openView(),
                  onChanged: (_) => controller.openView(),
                  leading: const Icon(Icons.search),
                  hintText: 'Ketik nama produk atau barcode...',
                );
              },
              suggestionsBuilder: (BuildContext context, SearchController controller) {
                final keyword = controller.text.toLowerCase();
                if (keyword.isEmpty) return [];

                final filteredProduk = _allProduk.where((produk) {
                  // PERBAIKAN: Menggunakan `namaProduk` dari model baru
                  final namaMatch = produk.namaProduk.toLowerCase().contains(keyword);
                  // PERBAIKAN: Menghilangkan null-aware operator yang tidak perlu
                  final barcodeMatch = produk.barcodeId.toLowerCase().contains(keyword);
                  return namaMatch || barcodeMatch;
                }).toList();

                return List<ListTile>.generate(filteredProduk.length, (int index) {
                  final item = filteredProduk[index];
                  return ListTile(
                    leading: const Icon(Icons.fastfood_outlined),
                    // PERBAIKAN: Menggunakan `namaProduk`
                    title: Text(item.namaProduk),
                    subtitle: Text('Barcode: ${item.barcodeId}'),
                    onTap: () {
                      setState(() {
                        // PERBAIKAN: Menggunakan `namaProduk`
                        controller.closeView(item.namaProduk);
                      });
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDetailPage(produk: item),
                      ));
                    },
                  );
                });
              },
            ),
          );
        },
      ),
    );
  }
}
