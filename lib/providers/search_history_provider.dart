import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchHistoryProvider with ChangeNotifier {
  List<Map<String, dynamic>> _history = [];

  List<Map<String, dynamic>> get history => _history;

  SearchHistoryProvider() {
    _loadHistory();
  }

  // Load history dari SharedPreferences (backward compatible)
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('search_history');
    
    if (historyJson != null) {
      final List<dynamic> decoded = jsonDecode(historyJson);
      _history = decoded.map((item) {
        return {
          'query': item['query'] as String,
          'timestamp': DateTime.parse(item['timestamp'] as String),
          // Jika data lama belum ada type, set default 'search'
          'type': item['type'] as String? ?? 'search',
        };
      }).toList();
      
      // Sort by newest first
      _history.sort((a, b) => 
        (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime)
      );
      
      notifyListeners();
    }
  }

  // Save history ke SharedPreferences
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = jsonEncode(
      _history.map((item) {
        return {
          'query': item['query'],
          'timestamp': (item['timestamp'] as DateTime).toIso8601String(),
          'type': item['type'],
        };
      }).toList(),
    );
    await prefs.setString('search_history', historyJson);
  }

  // Tambah pencarian manual (untuk ProductSearchPage)
  void addSearchQuery(String query) {
    if (query.trim().isEmpty) return;
    _addToHistory(query, 'search');
  }

  // Tambah hasil scan barcode (untuk future barcode scanner)
  void addScanResult(String productName) {
    if (productName.trim().isEmpty) return;
    _addToHistory(productName, 'scan');
  }

  // Internal method untuk tambah ke history
  void _addToHistory(String query, String type) {
    // Hapus duplicate dengan query dan type yang sama
    _history.removeWhere((item) => 
      item['query'] == query && item['type'] == type
    );

    // Tambah di awal list
    _history.insert(0, {
      'query': query,
      'timestamp': DateTime.now(),
      'type': type,
    });

    // Limit maksimal 100 history
    if (_history.length > 100) {
      _history = _history.sublist(0, 100);
    }

    _saveHistory();
    notifyListeners();
  }

  // Hapus satu item berdasarkan index
  void removeHistoryItem(int index) {
    if (index >= 0 && index < _history.length) {
      _history.removeAt(index);
      _saveHistory();
      notifyListeners();
    }
  }

  // Hapus satu item berdasarkan query (backward compatibility)
  void removeSearchQuery(String query) {
    _history.removeWhere((item) => item['query'] == query);
    _saveHistory();
    notifyListeners();
  }

  // Hapus semua history
  void clearHistory() {
    _history.clear();
    _saveHistory();
    notifyListeners();
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