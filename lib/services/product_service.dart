import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  final String _baseUrl = 'https://api-anda.com/search';

  Future<List<Product>> searchProducts(String query) async {
    final Uri baseUri = Uri.parse(_baseUrl);
    final Uri finalUri = baseUri.replace(
      queryParameters: {
        'query': query, 
      },
    );

    try {
      final response = await http
          .get(finalUri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        if (data.isEmpty) {
          return [];
        }

        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat produk (Error: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error koneksi: $e');
    }
  }
}
