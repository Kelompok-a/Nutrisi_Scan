
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'article_page.dart';
import 'faq_page.dart';
import 'about_page.dart';
import 'login_page.dart';
import 'register_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    ArticlePage(),
    FaqPage(),
    AboutPage(),
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
        title: Text('SugarChecker', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          _buildNavButton('Beranda', 0),
          _buildNavButton('Artikel', 1),
          _buildNavButton('Tanya Jawab', 2),
          _buildNavButton('Tentang', 3),
          SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPage()));
            },
            child: Text('Daftar'),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200),
          child: _pages[_selectedIndex],
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
          fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }
}
