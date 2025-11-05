import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/produk.dart';
import '../models/komposisi_gizi.dart';
import 'product_detail_page.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({super.key});

  @override
  State<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final ApiService _apiService = ApiService();
  late Future<List<Produk>> _produkFuture;
  late Future<List<KomposisiGizi>> _komposisiFuture;

  List<Produk> _allProduk = [];
  List<KomposisiGizi> _allKomposisi = [];

  @override
  void initState() {
    super.initState();
    // Memuat semua data saat halaman pertama kali dibuka
    _produkFuture = _apiService.getAllProduk();
    _komposisiFuture = _apiService.getAllKomposisi();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      // Menggunakan Future.wait untuk menunggu kedua future selesai
      future: Future.wait([_produkFuture, _komposisiFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada data yang ditemukan.'));
        }

        // Simpan data yang sudah dimuat
        _allProduk = snapshot.data![0] as List<Produk>;
        _allKomposisi = snapshot.data![1] as List<KomposisiGizi>;

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
                hintText: 'Cari nama produk...',
              );
            },
            suggestionsBuilder: (BuildContext context, SearchController controller) {
              final keyword = controller.text.toLowerCase();
              final filteredProduk = _allProduk.where((produk) {
                return produk.namaProduk.toLowerCase().contains(keyword);
              }).toList();

              return List<ListTile>.generate(filteredProduk.length, (int index) {
                final item = filteredProduk[index];
                return ListTile(
                  title: Text(item.namaProduk),
                  onTap: () {
                    // Cari komposisi yang cocok berdasarkan id_produk
                    final komposisi = _allKomposisi.firstWhere(
                      (k) => k.idProduk == item.id,
                      orElse: () => KomposisiGizi(id: 0, idProduk: 0, energi: 0, lemak: 0, protein: 0, karbohidrat: 0, gula: 0, garam: 0), // Fallback
                    );

                    setState(() {
                      controller.closeView(item.namaProduk);
                    });

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                        produk: item,
                        komposisi: komposisi,
                      ),
                    ));
                  },
                );
              });
            },
          ),
        );
      },
    );
  }
}
