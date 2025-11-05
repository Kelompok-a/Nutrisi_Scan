import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produk.dart';

class ApiService {
  // Mengembalikan _baseUrl ke versi sebelumnya sesuai permintaan
  static const String _baseUrl = 'http://localhost:3001/api';

  // Satu-satunya fungsi yang kita butuhkan sekarang
  Future<List<Produk>> getAllProduk() async {
    final uri = Uri.parse('$_baseUrl/produk');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        List<dynamic> data = body['data'];
        return data.map((json) => Produk.fromJson(json)).toList();
      } else {
        throw Exception(body['message'] ?? 'Gagal mengambil data produk');
      }
    } else {
      throw Exception('Gagal terhubung ke server');
    }
  }
}
