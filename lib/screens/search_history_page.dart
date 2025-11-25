import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_history_provider.dart';
import '../theme/app_theme.dart';

class SearchHistoryPage extends StatelessWidget {
  const SearchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<SearchHistoryProvider>(context);
    final history = historyProvider.history;
    final stats = historyProvider.getStatistics();

    return Scaffold(
      // Gunakan ListView.builder agar seluruh halaman bisa discroll (Solusi Zebra Bawah)
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: history.length + 1, // +1 untuk Header Statistik
        itemBuilder: (context, index) {
          // --- HEADER STATISTIK ---
          if (index == 0) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    // Warna Biru sesuai tema
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.kPrimaryColor,
                        AppTheme.kSecondaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.kPrimaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.bar_chart_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Statistik Aktivitas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            'Hari Ini',
                            stats['today']!,
                            Icons.today,
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.white30,
                          ),
                          _buildStatItem(
                            'Minggu Ini',
                            stats['week']!,
                            Icons.date_range,
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.white30,
                          ),
                          _buildStatItem(
                            'Bulan Ini',
                            stats['month']!,
                            Icons.calendar_month,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (history.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Terbaru',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

                if (history.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        Icon(
                          Icons.history,
                          size: 60,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Belum ada riwayat',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }

          // --- LIST ITEM ---
          final itemIndex = index - 1;
          final item = history[itemIndex];
          final isScan = item['type'] == 'scan';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                // Warna ikon disesuaikan
                backgroundColor: isScan
                    ? Colors.orange.shade50
                    : Colors.blue.shade50,
                child: Icon(
                  isScan ? Icons.qr_code : Icons.search,
                  color: isScan ? Colors.orange : AppTheme.kPrimaryColor,
                  size: 20,
                ),
              ),
              title: Text(
                item['query'],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                _formatSimpleDate(item['timestamp']),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                onPressed: () => historyProvider.removeHistoryItem(itemIndex),
              ),
            ),
          );
        },
      ),
      floatingActionButton: history.isNotEmpty
          ? FloatingActionButton(
              mini: true,
              backgroundColor: Colors.red,
              child: const Icon(Icons.delete_sweep, color: Colors.white),
              onPressed: () => _confirmClear(context, historyProvider),
            )
          : null,
    );
  }

  Widget _buildStatItem(String label, int count, IconData icon) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }

  String _formatSimpleDate(dynamic timestamp) {
    if (timestamp is DateTime) {
      return "${timestamp.day}/${timestamp.month} • ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
    }
    return timestamp.toString();
  }

  void _confirmClear(BuildContext context, SearchHistoryProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Semua?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              provider.clearHistory();
              Navigator.pop(ctx);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
