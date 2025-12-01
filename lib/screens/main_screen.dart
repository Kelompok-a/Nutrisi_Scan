import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
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
import 'admin/admin_layout.dart';

import 'nutrition_calculator_page.dart';

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
    const NutritionCalculatorPage(),
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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80, // Taller AppBar for premium feel
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              // Logo Area
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.health_and_safety,
                  color: theme.primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'NutriScan',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              
              const Spacer(),

              // Desktop/Tablet Navigation (Hidden on small screens if needed, but here we keep it)
              if (MediaQuery.of(context).size.width > 1100)
                Row(
                  children: [
                    _buildNavButton('Beranda', 0, Icons.home_rounded),
                    _buildNavButton('Cari', 1, Icons.search_rounded),
                    _buildNavButton('Kalkulator', 7, Icons.calculate_rounded),
                    _buildNavButton('Favorit', 5, Icons.favorite_rounded),
                    _buildNavButton('Riwayat', 6, Icons.history_rounded),
                    _buildNavButton('Artikel', 2, Icons.article_rounded),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Row(
              children: [
                // Theme Toggle
                IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    color: theme.iconTheme.color,
                  ),
                  onPressed: () {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                ),
                const SizedBox(width: 16),
                
                // Auth Section
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    if (authProvider.isAuthenticated) {
                      return Row(
                        children: [
                            if (authProvider.isAdmin)
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: MediaQuery.of(context).size.width > 600
                                    ? ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => const AdminLayout()),
                                          );
                                        },
                                        icon: const Icon(Icons.admin_panel_settings),
                                        label: const Text('Admin Panel'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          foregroundColor: Colors.white,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) => const AdminLayout()),
                                            );
                                          },
                                          icon: const Icon(Icons.admin_panel_settings),
                                          color: Colors.white,
                                          tooltip: 'Admin Panel',
                                        ),
                                      ),
                              ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const ProfilePage()),
                              );
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.primaryColor.withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: theme.primaryColor,
                                child: const Icon(Icons.person, color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Masuk'),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: theme.dividerColor.withOpacity(0.1),
            height: 1,
          ),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      
      // Mobile Bottom Navigation (Visible only on small screens)
      bottomNavigationBar: MediaQuery.of(context).size.width <= 1100
          ? NavigationBar(
              selectedIndex: _getBottomNavIndex(_selectedIndex),
              onDestinationSelected: (index) {
                // Map bottom nav items to page indices
                // 0: Home, 1: Search, 2: Calculator, 3: Favorites, 4: History
                int targetIndex = 0;
                if (index == 0) targetIndex = 0;
                if (index == 1) targetIndex = 1;
                if (index == 2) targetIndex = 7; // Calculator
                if (index == 3) targetIndex = 5; // Favorites
                if (index == 4) targetIndex = 6; // History
                _onItemTapped(targetIndex);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Beranda',
                ),
                NavigationDestination(
                  icon: Icon(Icons.search_outlined),
                  selectedIcon: Icon(Icons.search_rounded),
                  label: 'Cari',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calculate_outlined),
                  selectedIcon: Icon(Icons.calculate_rounded),
                  label: 'Hitung',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border_rounded),
                  selectedIcon: Icon(Icons.favorite_rounded),
                  label: 'Favorit',
                ),
                NavigationDestination(
                  icon: Icon(Icons.history_rounded),
                  selectedIcon: Icon(Icons.history_rounded),
                  label: 'Riwayat',
                ),
              ],
            )
          : null,
    );
  }

  int _getBottomNavIndex(int pageIndex) {
    if (pageIndex == 0) return 0; // Home
    if (pageIndex == 1) return 1; // Search
    if (pageIndex == 7) return 2; // Calculator
    if (pageIndex == 5) return 3; // Favorites
    if (pageIndex == 6) return 4; // History
    return 0; // Default to Home for other pages (Articles, FAQ, About)
  }

  Widget _buildNavButton(String text, int index, IconData icon) {
    final isSelected = _selectedIndex == index;
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton.icon(
        onPressed: () => _onItemTapped(index),
        icon: Icon(
          icon,
          size: 20,
          color: isSelected ? theme.primaryColor : theme.iconTheme.color?.withOpacity(0.7),
        ),
        label: Text(
          text,
          style: TextStyle(
            color: isSelected ? theme.primaryColor : theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: isSelected ? theme.primaryColor.withOpacity(0.05) : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
