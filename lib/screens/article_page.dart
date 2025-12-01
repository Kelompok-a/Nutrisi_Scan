import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/footer.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kBackgroundColor,
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            decoration: BoxDecoration(
              color: AppTheme.kSurfaceColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.kPrimaryColor.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Edukasi Kesehatan',
                    style: TextStyle(
                      color: AppTheme.kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Artikel & Tips Sehat',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.kTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Informasi penting untuk menjaga kesehatan gula darah dan pola makan Anda.',
                  style: TextStyle(
                    color: AppTheme.kSubTextColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Articles List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                _buildArticleCard(
                  context,
                  'Penyebab Gula Darah Tinggi',
                  'Gula darah tinggi atau hiperglikemia adalah kondisi yang terjadi ketika kadar glukosa dalam darah lebih tinggi dari normal. Beberapa penyebab umumnya termasuk pola makan tidak sehat, kurangnya aktivitas fisik, stres, dan kondisi medis tertentu seperti diabetes.',
                  Icons.show_chart_rounded,
                ),
                _buildArticleCard(
                  context,
                  'Gejala Gula Darah Tinggi',
                  'Gejala awal gula darah tinggi seringkali tidak terasa. Namun, beberapa gejala yang mungkin muncul antara lain sering merasa haus, sering buang air kecil, kelelahan, penglihatan kabur, dan luka yang sulit sembuh.',
                  Icons.warning_amber_rounded,
                ),
                _buildArticleCard(
                  context,
                  'Cara Menurunkan Gula Darah',
                  'Mengelola gula darah dapat dilakukan dengan beberapa cara, seperti mengadopsi pola makan sehat rendah gula dan karbohidrat, berolahraga secara teratur, menjaga berat badan ideal, mengelola stres, dan minum air yang cukup.',
                  Icons.favorite_rounded,
                ),
                _buildArticleCard(
                  context,
                  'Mengapa Perlu Scan Barcode Makanan?',
                  'Banyak produk kemasan memiliki label nutrisi yang membingungkan atau sulit dibaca. Dengan fitur Scan Barcode di NutriScan, Anda bisa langsung mengetahui kandungan gula, lemak, dan kalori secara instan tanpa perlu menghitung manual. Ini membantu Anda menghindari produk yang terlihat sehat padahal tinggi gula.',
                  Icons.qr_code_scanner_rounded,
                ),
                _buildArticleCard(
                  context,
                  'Cara Membaca Informasi Nilai Gizi',
                  'Perhatikan "Takaran Saji" pada label. Seringkali, satu kemasan berisi lebih dari satu sajian. Jika Anda menghabiskan seluruh kemasan, Anda mungkin mengonsumsi 2-3 kali lipat kalori dan gula yang tertulis di label. NutriScan membantu menampilkan total kandungan secara lebih transparan.',
                  Icons.menu_book_rounded,
                ),
                _buildArticleCard(
                  context,
                  'Memahami % AKG (Angka Kecukupan Gizi)',
                  'Persentase AKG menunjukkan seberapa banyak nutrisi dalam makanan tersebut memenuhi kebutuhan harian Anda. Jika sebuah camilan memiliki Gula 50% AKG, artinya satu camilan itu sudah menghabiskan setengah "jatah" gula harian Anda. NutriScan menyoroti angka ini agar Anda lebih waspada.',
                  Icons.pie_chart_rounded,
                ),
                _buildArticleCard(
                  context,
                  'Waspada Nama Lain dari Gula',
                  'Gula tidak selalu ditulis sebagai "Gula". Produsen sering menggunakan nama lain seperti Sirup Jagung Tinggi Fruktosa, Dekstrosa, Maltodekstrin, atau Sukrosa. NutriScan mendeteksi total gula dalam produk untuk memastikan Anda tidak terkecoh oleh istilah-istilah ini.',
                  Icons.search_rounded,
                ),
                _buildArticleCard(
                  context,
                  'Tips Belanja Sehat dengan NutriScan',
                  'Sebelum memasukkan produk ke keranjang belanja, lakukan scan cepat. Bandingkan dua produk sejenis (misalnya dua merek susu cokelat) dan pilihlah yang memiliki kandungan gula dan lemak jenuh paling rendah. Perubahan kecil dalam pemilihan produk dapat berdampak besar bagi kesehatan jangka panjang.',
                  Icons.shopping_cart_rounded,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          const Footer(),
        ],
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: AppTheme.kSurfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.kPrimaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.kPrimaryColor, size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppTheme.kTextColor,
            ),
          ),
          children: [
            Text(
              content,
              style: TextStyle(
                fontSize: 15.0,
                color: AppTheme.kSubTextColor,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
