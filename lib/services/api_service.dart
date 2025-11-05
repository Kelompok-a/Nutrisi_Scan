import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produk.dart';
import '../models/komposisi_gizi.dart';

class ApiService {
  // Mengubah Base URL ke port 3001
  static const String _baseUrl = 'http://localhost:3001/api';
  // Mengambil semua produk dari backend
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

  // Mengambil semua komposisi gizi dari backend
  Future<List<KomposisiGizi>> getAllKomposisi() async {
    final uri = Uri.parse('$_baseUrl/komposisi');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        List<dynamic> data = body['data'];
        return data.map((json) => KomposisiGizi.fromJson(json)).toList();
      } else {
        throw Exception(body['message'] ?? 'Gagal mengambil data komposisi');
      }
    } else {
      throw Exception('Gagal terhubung ke server');
    }
  }
}
