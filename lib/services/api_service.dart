import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produk.dart';

class ApiService {
  // DIKEMBALIKAN: Sesuai instruksi, tidak akan diubah lagi.
  static const String baseUrl = 'http://localhost:3001/api';

  // FUNGSI LAMA: Mengambil SATU produk berdasarkan barcode
  Future<Produk> getProduk(String barcode) async {
    final uri = Uri.parse('$baseUrl/produk/$barcode');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          return Produk.fromJson(body['data']);
        } else {
          throw Exception(body['message'] ?? 'Produk tidak ditemukan');
        }
      } else {
        throw Exception('Gagal terhubung ke server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // FUNGSI BARU: Mengambil SEMUA produk untuk dropdown pencarian
  Future<List<Produk>> getAllProduk() async {
    final uri = Uri.parse('$baseUrl/produk');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          List<dynamic> data = body['data'];
          return data.map((json) => Produk.fromJson(json)).toList();
        } else {
          throw Exception(body['message'] ?? 'Gagal memuat daftar produk');
        }
      } else {
        throw Exception('Gagal terhubung ke server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
