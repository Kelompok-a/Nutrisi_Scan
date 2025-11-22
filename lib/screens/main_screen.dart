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

class MainScreen extends StatefulWidget {
  const MainScreen({super.key}); 

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ProductSearchPage(),
    ArticlePage(),
    FaqPage(),
    AboutPage(),
    FavoritesPage(),        
    SearchHistoryPage(),    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, 
      appBar: AppBar(
        title: Text(
          'SugarChecker',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          _buildNavButton('Beranda', 0),
          _buildNavButton('Cari Produk', 1),
          _buildNavButton('Artikel', 2),
          _buildNavButton('Tanya Jawab', 3),
          _buildNavButton('Tentang', 4),
          _buildNavButton('Favorit', 5),    
          _buildNavButton('Riwayat', 6),    
          SizedBox(width: 20),

          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.isAuthenticated) {
                return Tooltip(
                  message: 'Profil',
                  child: IconButton(
                    icon: const Icon(Icons.person, color: Colors.black87),
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
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0056b3),
                        foregroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: Text('Daftar'),
                    ),
                    SizedBox(width: 20),
                  ],
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200),
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
          color: _selectedIndex == index ? Color(0xFF0056b3) : Colors.black54,
          fontWeight: _selectedIndex == index
              ? FontWeight.bold
              : FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }
}