import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'article_page.dart';
import 'faq_page.dart';
import 'about_page.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'product_search_page.dart';
import 'search_history_page.dart';
import 'favorites_page.dart';
import '../theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ProductSearchPage(),
    const ArticlePage(),
    const FaqPage(),
    const AboutPage(),
    const FavoritesPage(),
    const SearchHistoryPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NutriScan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        // --- PERBAIKAN DI SINI (Actions dibungkus agar bisa discroll) ---
        actions: [
          // Gunakan Container dengan constraint lebar maksimal layar
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: SingleChildScrollView(
              scrollDirection:
                  Axis.horizontal, // Scroll ke samping jika tidak muat
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNavButton('Beranda', 0),
                  _buildNavButton('Cari Produk', 1),
                  _buildNavButton('Artikel', 2),
                  _buildNavButton('Tanya Jawab', 3),
                  _buildNavButton('Tentang', 4),
                  _buildNavButton('Favorit', 5),
                  _buildNavButton('Riwayat', 6),
                  const SizedBox(width: 20),

                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      if (authProvider.isAuthenticated) {
                        return Tooltip(
                          message: 'Profil',
                          child: IconButton(
                            icon: const Icon(
                              Icons.person,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ProfilePage(),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.kPrimaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                minimumSize: const Size(0, 36),
                              ),
                              child: const Text('Login'),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text('Daftar'),
                            ),
                            const SizedBox(width: 20),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: IndexedStack(index: _selectedIndex, children: _pages),
        ),
      ),
    );
  }

  Widget _buildNavButton(String text, int index) {
    return TextButton(
      onPressed: () => _onItemTapped(index),
      child: Text(
        text,
        style: TextStyle(
          color: _selectedIndex == index
              ? AppTheme.kPrimaryColor
              : Colors.black54,
          fontWeight: _selectedIndex == index
              ? FontWeight.bold
              : FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }
}
