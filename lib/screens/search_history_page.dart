import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_history_provider.dart';

class SearchHistoryPage extends StatelessWidget {
  const SearchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<SearchHistoryProvider>(context);
    final history = historyProvider.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pencarian'),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black, 
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Bersihkan Riwayat',
            onPressed: () {
              if (history.isEmpty) return; 
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Konfirmasi'),
                  content: const Text('Anda yakin ingin menghapus semua riwayat?'),
                  actions: [
                    TextButton(
                      child: const Text('Batal'),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                    TextButton(
                      child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        historyProvider.clearHistory();
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'Belum ada riwayat pencarian.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final query = history[index];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(query),
                  onTap: () {
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      historyProvider.removeSearchQuery(query);
                    },
                  ),
                );
              },
            ),
    );
  }
}