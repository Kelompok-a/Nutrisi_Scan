import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchHistoryProvider with ChangeNotifier {
  List<Map<String, dynamic>> _history = [];
  final _storage = const FlutterSecureStorage();
  final String _baseUrl = 'http://localhost:3001'; // Sesuaikan dengan URL server

  List<Map<String, dynamic>> get history => _history;

  SearchHistoryProvider() {
    fetchHistory();
  }

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Fetch history from API
  Future<void> fetchHistory() async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/history'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true) {
          final List<dynamic> data = body['data'];
          _history = data.map((item) {
            return {
              'id': item['id_history'],
              'query': item['query'],
              'timestamp': DateTime.parse(item['timestamp']),
              'type': item['type'],
            };
          }).toList();
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error fetching history: $e');
    }
  }

  // Tambah pencarian manual
  void addSearchQuery(String query) {
    if (query.trim().isEmpty) return;
    _addToHistory(query, 'search');
  }

  // Tambah hasil scan barcode
  void addScanResult(String productName) {
    if (productName.trim().isEmpty) return;
    _addToHistory(productName, 'scan');
  }

  // Internal method untuk tambah ke history via API
  Future<void> _addToHistory(String query, String type) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/history'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'query': query, 'type': type}),
      );

      if (response.statusCode == 200) {
        await fetchHistory(); // Refresh list from server
      }
    } catch (e) {
      print('Error adding history: $e');
    }
  }

  // Hapus satu item berdasarkan index (sekarang pakai ID)
  Future<void> removeHistoryItem(int index) async {
    if (index < 0 || index >= _history.length) return;
    
    final item = _history[index];
    final id = item['id'];
    
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/history/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        _history.removeAt(index);
        notifyListeners();
      }
    } catch (e) {
      print('Error removing history: $e');
    }
  }

  // Hapus semua history
  Future<void> clearHistory() async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/api/history'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        _history.clear();
        notifyListeners();
      }
    } catch (e) {
      print('Error clearing history: $e');
    }
  }

  // Hitung statistik gabungan
  Map<String, int> getStatistics() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAgo = today.subtract(const Duration(days: 7));
    final monthAgo = DateTime(now.year, now.month - 1, now.day);

    int todayCount = 0;
    int weekCount = 0;
    int monthCount = 0;

    for (var item in _history) {
      final timestamp = item['timestamp'] as DateTime;
      final date = DateTime(timestamp.year, timestamp.month, timestamp.day);

      if (date.isAtSameMomentAs(today)) {
        todayCount++;
      }
      
      if (timestamp.isAfter(weekAgo)) {
        weekCount++;
      }
      
      if (timestamp.isAfter(monthAgo)) {
        monthCount++;
      }
    }

    return {
      'today': todayCount,
      'week': weekCount,
      'month': monthCount,
    };
  }
}