import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produk.dart';

class ApiService {
  // Pastikan baseUrl ini benar. Gunakan 'http://10.0.2.2:3001' untuk emulator Android.
  static const String baseUrl = 'http://localhost:3001';

  Future<List<Produk>> getAllProduk() async {
    final uri = Uri.parse('$baseUrl/api/produk');
    try {
      final response = await http.get(uri);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        // Parsing data dari key 'data'
        List<dynamic> data = body['data'];
        return data.map((json) => Produk.fromJson(json)).toList();
      } else {
        throw Exception(body['message'] ?? 'Gagal mengambil data produk');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: ${e.toString()}');
    }
  }

  Future<Produk> getProdukByBarcode(String barcode) async {
    final uri = Uri.parse('$baseUrl/api/produk/$barcode');
    try {
      final response = await http.get(uri);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        // Parsing data dari key 'data'
        return Produk.fromJson(body['data']);
      } else {
        throw Exception(body['message'] ?? 'Gagal mengambil detail produk');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: ${e.toString()}');
    }
  }
}
