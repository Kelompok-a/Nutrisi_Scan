import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produk.dart';

class ApiService {
  // Ganti 'YOUR_COMPUTER_IP' dengan alamat IP lokal komputer Anda
  // jika Anda menjalankan aplikasi di perangkat fisik.
  // Gunakan '10.0.2.2' jika Anda menggunakan Emulator Android.
  static const String baseUrl = 'http://10.0.2.2:3001/api';

  // Fungsi untuk mengambil SATU produk berdasarkan barcode
  Future<Produk> getProduk(String barcode) async {
    final uri = Uri.parse('$baseUrl/produk/$barcode');
    
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          // Backend mengembalikan satu objek, bukan list
          return Produk.fromJson(body['data']);
        } else {
          // Menangani kasus ketika produk tidak ditemukan atau ada error dari server
          throw Exception(body['message'] ?? 'Produk tidak ditemukan');
        }
      } else {
        // Menangani error koneksi HTTP
        throw Exception('Gagal terhubung ke server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Menangani error umum (misal: tidak ada koneksi internet)
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
