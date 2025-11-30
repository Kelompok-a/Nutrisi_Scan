import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final _storage = const FlutterSecureStorage();

  String? _token;
  String? _namaPengguna;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get namaPengguna => _namaPengguna;

  Future<bool> tryAutoLogin() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null) {
      return false;
    }
    _token = token;
    _namaPengguna = await _storage.read(key: 'user_nama');
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await _authService.login(email, password);
    if (result['success'] == true) {
      await tryAutoLogin();
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

  Future<Map<String, dynamic>> updateProfile(String nama) async {
    final result = await _authService.updateProfile(nama);
    if (result['success'] == true) {
      _namaPengguna = nama;
      notifyListeners();
    }
    return result;
  }

  Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword) async {
    return await _authService.changePassword(oldPassword, newPassword);
  }
}
