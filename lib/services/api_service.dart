import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:3000/api';

  Future<User> login(String name) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User(name: data['user']['name']);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Gagal untuk login');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    // Buat URI dengan query parameter
    final uri = Uri.parse('$_baseUrl/products').replace(queryParameters: {'search': query});

    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Jika server mengembalikan 200 OK, parse JSON
      final List<dynamic> data = jsonDecode(response.body);
      // Ubah setiap item di list menjadi objek Product
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      // Jika terjadi error, lempar exception
      throw Exception('Gagal memuat produk');
    }
  }
}
