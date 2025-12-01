import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class AdminService {
  static const String _baseUrl = 'http://localhost:3001';
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<List<User>> getAllUsers() async {
    final uri = Uri.parse('$_baseUrl/api/users');
    final token = await _getToken();
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        List<dynamic> data = body['data'];
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception(body['message'] ?? 'Gagal mengambil data user');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: ${e.toString()}');
    }
  }

  Future<bool> deleteUser(String id) async {
    final uri = Uri.parse('$_baseUrl/api/users/$id');
    final token = await _getToken();
    try {
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final body = jsonDecode(response.body);
      return body['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
