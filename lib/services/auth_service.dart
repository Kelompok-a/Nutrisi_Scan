import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

class AuthService {
  // static const String _baseUrl = 'http://localhost:3001'; // Removed in favor of ApiService
  final _storage = const FlutterSecureStorage();
  
  String get _baseUrl => ApiService.baseUrl;

  // --- FUNGSI REGISTER DIHIDUPKAN KEMBALI ---
  Future<Map<String, dynamic>> register({required String nama, required String email, required String password}) async {
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
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Kesalahan jaringan: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final uri = Uri.parse('$_baseUrl/api/login');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        final data = body['data'];
        await _storage.write(key: 'jwt_token', value: data['token']);
        await _storage.write(key: 'user_nama', value: data['user']['nama']);
        // Simpan role jika ada, default ke 'user' jika tidak ada
        await _storage.write(key: 'user_role', value: data['user']['role'] ?? 'user');
      }
      return body;
    } catch (e) {
      return {'success': false, 'message': 'Kesalahan jaringan: ${e.toString()}'};
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'user_nama');
    await _storage.delete(key: 'user_role');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<Map<String, dynamic>> updateProfile(String nama) async {
    final uri = Uri.parse('$_baseUrl/api/profile');
    final token = await getToken();
    try {
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'nama': nama}),
      );

      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        final data = body['data'];
        await _storage.write(key: 'user_nama', value: data['user']['nama']);
      }
      return body;
    } catch (e) {
      return {'success': false, 'message': 'Kesalahan jaringan: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword) async {
    final uri = Uri.parse('$_baseUrl/api/profile/password');
    final token = await getToken();
    try {
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Kesalahan jaringan: ${e.toString()}'};
    }
  }
}
