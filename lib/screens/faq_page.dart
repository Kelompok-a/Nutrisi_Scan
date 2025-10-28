
import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          _buildFaqItem(
            'Berapa kadar gula darah normal?',
            'Kadar gula darah normal saat puasa adalah antara 70-100 mg/dL. Setelah makan, kadar gula darah normalnya di bawah 140 mg/dL.',
          ),
          _buildFaqItem(
            'Apakah aplikasi ini bisa menggantikan dokter?',
            'Tidak. Aplikasi ini hanya alat bantu untuk memantau kadar gula darah Anda. Konsultasikan selalu dengan dokter atau tenaga medis profesional untuk diagnosis dan pengobatan.',
          ),
          _buildFaqItem(
            'Seberapa sering saya harus memeriksa gula darah?',
            'Frekuensi pemeriksaan gula darah tergantung pada kondisi kesehatan Anda. Diskusikan dengan dokter Anda untuk mengetahui jadwal pemeriksaan yang paling sesuai.',
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
