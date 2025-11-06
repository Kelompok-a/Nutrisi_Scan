import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final _storage = const FlutterSecureStorage();

  String? _token;
  String? _namaPengguna; // Diubah dari _username ke _namaPengguna
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get namaPengguna => _namaPengguna; // Getter baru

  Future<bool> tryAutoLogin() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) {
      return false;
    }
    _token = token;
    _namaPengguna = await _storage.read(key: 'user_nama'); // Baca nama pengguna
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await _authService.login(email, password);
    if (result['success'] == true) {
      await tryAutoLogin(); // Panggil tryAutoLogin untuk set state
    }
    return result;
  }

  Future<void> logout() async {
    _token = null;
    _namaPengguna = null;
    _isAuthenticated = false;
    await _authService.logout();
    notifyListeners();
  }
}
