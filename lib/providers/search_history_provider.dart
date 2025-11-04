import 'package:flutter/material.dart';

class SearchHistoryProvider with ChangeNotifier {
  final List<String> _history = [];
  List<String> get history => [..._history];

  void addSearchQuery(String query) {
    if (query.isEmpty) return;
    _history.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
    _history.insert(0, query);
    if (_history.length > 10) {
      _history.removeLast();
    }
    
    notifyListeners();
  }

  void removeSearchQuery(String query) {
    _history.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}