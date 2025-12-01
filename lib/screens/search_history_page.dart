import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_history_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/footer.dart';

import '../providers/auth_provider.dart';
import 'login_page.dart';

class SearchHistoryPage extends StatelessWidget {
  const SearchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<SearchHistoryProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final history = historyProvider.history;
    final stats = historyProvider.getStatistics();

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        backgroundColor: AppTheme.kBackgroundColor,
        appBar: AppBar(
          title: const Text('Riwayat Pencarian'),
          backgroundColor: AppTheme.kSurfaceColor,
          elevation: 0,
          foregroundColor: AppTheme.kTextColor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppTheme.kPrimaryColor.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline_rounded,
                  size: 80,
                  color: AppTheme.kPrimaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Login Diperlukan',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.kTextColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Silakan login terlebih dahulu untuk\nmelihat riwayat pencarian Anda',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.kSubTextColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.kPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Login Sekarang'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      appBar: AppBar(
        title: const Text('Riwayat Pencarian'),
        backgroundColor: AppTheme.kSurfaceColor,
        elevation: 0,
        foregroundColor: AppTheme.kTextColor,
      ),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: history.length + 2, // +1 for Header, +1 for Footer
        itemBuilder: (context, index) {
          // --- HEADER STATISTIK ---
          if (index == 0) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppTheme.kPrimaryGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.kPrimaryColor.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.insights_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Statistik Aktivitas',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            'Hari Ini',
                            stats['today']!,
                            Icons.today_rounded,
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.white24,
                          ),
                          _buildStatItem(
                            'Minggu Ini',
                            stats['week']!,
                            Icons.date_range_rounded,
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.white24,
                          ),
                          _buildStatItem(
                            'Bulan Ini',
                            stats['month']!,
                            Icons.calendar_month_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (history.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Terbaru',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.kTextColor,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _confirmClear(context, historyProvider),
                          icon: const Icon(Icons.delete_sweep_rounded, size: 18),
                          label: const Text('Hapus Semua'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.kErrorColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                if (history.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 64, bottom: 64),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.kSubTextColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.history_rounded,
                            size: 64,
                            color: AppTheme.kSubTextColor.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada riwayat pencarian',
                          style: TextStyle(
                            color: AppTheme.kSubTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }

          // --- FOOTER ---
          if (index == history.length + 1) {
            return const Padding(
              padding: EdgeInsets.only(top: 32.0),
              child: Footer(),
            );
          }

          // --- LIST ITEM ---
          final itemIndex = index - 1;
          final item = history[itemIndex];
          final isScan = item['type'] == 'scan';

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.kSurfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.kPrimaryColor.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isScan
                      ? Colors.orange.withOpacity(0.1)
                      : AppTheme.kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isScan ? Icons.qr_code_rounded : Icons.search_rounded,
                  color: isScan ? Colors.orange : AppTheme.kPrimaryColor,
                  size: 24,
                ),
              ),
              title: Text(
                item['query'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.kTextColor,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _formatSimpleDate(item['timestamp']),
                  style: TextStyle(fontSize: 12, color: AppTheme.kSubTextColor),
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close_rounded, size: 20, color: AppTheme.kSubTextColor),
                onPressed: () => historyProvider.removeHistoryItem(itemIndex),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, int count, IconData icon) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
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
        content: const Text('Riwayat pencarian Anda akan dihapus secara permanen.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
            child: const Text('Hapus', style: TextStyle(color: AppTheme.kErrorColor)),
          ),
        ],
      ),
    );
  }
}
