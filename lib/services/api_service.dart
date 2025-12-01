import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produk.dart';

class ApiService {
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

  Future<bool> addProduk(Produk produk) async {
    final uri = Uri.parse('$baseUrl/api/produk');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(produk.toJson()),
      );
      final body = jsonDecode(response.body);
      return body['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProduk(Produk produk) async {
    final uri = Uri.parse('$baseUrl/api/produk/${produk.barcode}');
    try {
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(produk.toJson()),
      );
      final body = jsonDecode(response.body);
      return body['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduk(String barcode) async {
    final uri = Uri.parse('$baseUrl/api/produk/$barcode');
    try {
      final response = await http.delete(uri);
      final body = jsonDecode(response.body);
      return body['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
