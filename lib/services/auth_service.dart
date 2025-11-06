import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String _baseUrl = 'http://localhost:3001'; // Gunakan 'http://10.0.2.2:3001' untuk emulator Android
  final _storage = const FlutterSecureStorage();

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
        await _storage.write(key: 'jwt_token', value: body['token']);
        await _storage.write(key: 'user_nama', value: body['user']['nama']);
      }
      return body;
    } catch (e) {
      return {'success': false, 'message': 'Kesalahan jaringan: ${e.toString()}'};
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'user_nama');
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }
}
