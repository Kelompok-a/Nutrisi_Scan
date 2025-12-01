import 'package:flutter/material.dart';
import '../../models/produk.dart';
import '../../services/api_service.dart';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  final ApiService _apiService = ApiService();
  late Future<List<Produk>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _apiService.getAllProduk();
  }

  void _refreshProducts() {
    setState(() {
      _productsFuture = _apiService.getAllProduk();
    });
  }

  Future<void> _deleteProduct(String barcode) async {
    final success = await _apiService.deleteProduk(barcode);
    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil dihapus')),
        );
        _refreshProducts();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus produk')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Product Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(
              onPressed: () {
                _showProductDialog(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: FutureBuilder<List<Produk>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada produk'));
              }

              final products = snapshot.data!;
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: product.gambarUrl != null
                          ? Image.network(product.gambarUrl!, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported))
                          : const Icon(Icons.image),
                      title: Text(product.namaProduk),
                      subtitle: Text('Barcode: ${product.barcode}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showProductDialog(context, product: product),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteConfirmation(context, product),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, Produk product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text('Apakah Anda yakin ingin menghapus ${product.namaProduk}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct(product.barcode);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showProductDialog(BuildContext context, {Produk? product}) {
    final isEditing = product != null;
    final barcodeController = TextEditingController(text: product?.barcode ?? '');
    final namaController = TextEditingController(text: product?.namaProduk ?? '');
    final gambarController = TextEditingController(text: product?.gambarUrl ?? '');
    // Add other controllers as needed

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Produk' : 'Tambah Produk'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: barcodeController,
                decoration: const InputDecoration(labelText: 'Barcode'),
                enabled: !isEditing, // Barcode shouldn't change on edit usually
              ),
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
              ),
              TextField(
                controller: gambarController,
                decoration: const InputDecoration(labelText: 'URL Gambar'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              final newProduct = Produk(
                barcodeId: barcodeController.text,
                namaProduk: namaController.text,
                imageProductLink: gambarController.text.isNotEmpty ? gambarController.text : null,
                // Default values for required fields
                totalCalories: product?.totalCalories ?? 0.0,
                totalFat: product?.totalFat ?? 0.0,
                saturatedFat: product?.saturatedFat ?? 0.0,
                totalSugar: product?.totalSugar ?? 0.0,
                protein: product?.protein ?? 0.0,
                akgProtein: product?.akgProtein ?? 0.0,
                totalCarbohydrates: product?.totalCarbohydrates ?? 0.0,
                akgCarbohydrates: product?.akgCarbohydrates ?? 0.0,
                akgSaturatedFat: product?.akgSaturatedFat ?? 0.0,
              );

              bool success;
              if (isEditing) {
                success = await _apiService.updateProduk(newProduct);
              } else {
                success = await _apiService.addProduk(newProduct);
              }

              if (mounted) {
                Navigator.pop(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEditing ? 'Produk diperbarui' : 'Produk ditambahkan')),
                  );
                  _refreshProducts();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal menyimpan produk')),
                  );
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
