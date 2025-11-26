import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NutriScan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                width: 1,
              ),
            ),
          ),
        ),
        actions: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
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
                            icon: const Icon(Icons.person),
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
                          ],
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    ),
                    onPressed: () {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                    },
                  ),
                  const SizedBox(width: 20),
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
    final theme = Theme.of(context);
    final isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () => _onItemTapped(index),
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? theme.primaryColor.withOpacity(0.1) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? theme.primaryColor : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
