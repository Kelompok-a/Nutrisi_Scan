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
            'Mengelola gula darah dapat dilakukan dengan beberapa cara, seperti mengadopsi pola makan sehat rendah gula dan karbohidrat, berolahraga secara teratur, menjaga berat badan ideal, mengelola stres, dan minum air yang cukup.',
          ),
          _buildArticleCard(
            'Mengapa Perlu Scan Barcode Makanan?',
            'Banyak produk kemasan memiliki label nutrisi yang membingungkan atau sulit dibaca. Dengan fitur Scan Barcode di NutriScan, Anda bisa langsung mengetahui kandungan gula, lemak, dan kalori secara instan tanpa perlu menghitung manual. Ini membantu Anda menghindari produk yang terlihat sehat padahal tinggi gula.',
          ),
          _buildArticleCard(
            'Cara Membaca Informasi Nilai Gizi',
            'Perhatikan "Takaran Saji" pada label. Seringkali, satu kemasan berisi lebih dari satu sajian. Jika Anda menghabiskan seluruh kemasan, Anda mungkin mengonsumsi 2-3 kali lipat kalori dan gula yang tertulis di label. NutriScan membantu menampilkan total kandungan secara lebih transparan.',
          ),
          _buildArticleCard(
            'Memahami % AKG (Angka Kecukupan Gizi)',
            'Persentase AKG menunjukkan seberapa banyak nutrisi dalam makanan tersebut memenuhi kebutuhan harian Anda. Jika sebuah camilan memiliki Gula 50% AKG, artinya satu camilan itu sudah menghabiskan setengah "jatah" gula harian Anda. NutriScan menyoroti angka ini agar Anda lebih waspada.',
          ),
          _buildArticleCard(
            'Waspada Nama Lain dari Gula',
            'Gula tidak selalu ditulis sebagai "Gula". Produsen sering menggunakan nama lain seperti Sirup Jagung Tinggi Fruktosa, Dekstrosa, Maltodekstrin, atau Sukrosa. NutriScan mendeteksi total gula dalam produk untuk memastikan Anda tidak terkecoh oleh istilah-istilah ini.',
          ),
          _buildArticleCard(
            'Tips Belanja Sehat dengan NutriScan',
            'Sebelum memasukkan produk ke keranjang belanja, lakukan scan cepat. Bandingkan dua produk sejenis (misalnya dua merek susu cokelat) dan pilihlah yang memiliki kandungan gula dan lemak jenuh paling rendah. Perubahan kecil dalam pemilihan produk dapat berdampak besar bagi kesehatan jangka panjang.',
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(String title, String content) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0056b3), // Warna Biru Utama sesuai tema
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              content,
              style: const TextStyle(
                fontSize: 15.0,
                color: Colors.black87,
                height: 1.5, // Jarak antar baris agar enak dibaca
              ),
              textAlign: TextAlign.justify, // Rata kanan-kiri
            ),
          ],
        ),
      ),
    );
  }
}
