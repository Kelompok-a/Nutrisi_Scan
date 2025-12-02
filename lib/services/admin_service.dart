import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import 'api_service.dart';

class AdminService {
  static String get _baseUrl => ApiService.baseUrl;
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<List<User>> getAllUsers() async {
    final uri = Uri.parse('$_baseUrl/api/admin/users');
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
    final uri = Uri.parse('$_baseUrl/api/admin/users/$id');
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

  Future<Map<String, dynamic>> getDashboardStats() async {
    final uri = Uri.parse('$_baseUrl/api/admin/stats');
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
        return body['data'];
      } else {
        throw Exception(body['message'] ?? 'Gagal mengambil statistik');
      }
    } catch (e) {
      throw Exception('Kesalahan jaringan: ${e.toString()}');
    }
  }

  Future<bool> createUser(String nama, String email, String password) async {
    final uri = Uri.parse('$_baseUrl/api/register');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'password': password,
        }),
      );
      final body = jsonDecode(response.body);
      return body['success'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateUser(String id, String nama, String role, String? password) async {
    final uri = Uri.parse('$_baseUrl/api/admin/users/$id');
    final token = await _getToken();
    try {
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nama': nama,
          'role': role,
          if (password != null && password.isNotEmpty) 'password': password,
        }),
      );

      final body = jsonDecode(response.body);
      return body['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
