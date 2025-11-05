import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Mengembalikan ke fungsi login simulasi untuk sementara
  Future<void> login(String name, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulasi jeda jaringan
    await Future.delayed(const Duration(seconds: 1));

    // Logika simulasi: login berhasil jika nama tidak kosong
    if (name.isNotEmpty && password.isNotEmpty) {
      _user = User(name: name);
      _errorMessage = null;
    } else {
      _errorMessage = "Nama dan password tidak boleh kosong.";
    }

    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
