
import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildArticleCard(
            'Penyebab Gula Darah Tinggi',
            'Gula darah tinggi atau hiperglikemia adalah kondisi yang terjadi ketika kadar glukosa dalam darah lebih tinggi dari normal. Beberapa penyebab umumnya termasuk pola makan tidak sehat, kurangnya aktivitas fisik, stres, dan kondisi medis tertentu seperti diabetes.',
          ),
          _buildArticleCard(
            'Gejala Gula Darah Tinggi',
            'Gejala awal gula darah tinggi seringkali tidak terasa. Namun, beberapa gejala yang mungkin muncul antara lain sering merasa haus, sering buang air kecil, kelelahan, penglihatan kabur, dan luka yang sulit sembuh.',
          ),
          _buildArticleCard(
            'Cara Menurunkan Gula Darah',
            'Mengelola gula darah dapat dilakukan dengan beberapa cara, seperti mengadopsi pola makan sehat rendah gula dan karbohidrat, berolahraga secara teratur, menjaga berat badan ideal, mengelola stres, dan minum air yang cukup.',
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(String title, String content) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Text(
              content,
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
