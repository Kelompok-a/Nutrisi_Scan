class KomposisiGizi {
  final int id;
  final int idProduk;
  final double energi;
  final double lemak;
  final double protein;
  final double karbohidrat;
  final double gula;
  final double garam;

  KomposisiGizi({
    required this.id,
    required this.idProduk,
    required this.energi,
    required this.lemak,
    required this.protein,
    required this.karbohidrat,
    required this.gula,
    required this.garam,
  });

  factory KomposisiGizi.fromJson(Map<String, dynamic> json) {
    return KomposisiGizi(
      // PERBAIKAN: Gunakan operator '??' untuk nilai default
      id: json['id_komposisi'] ?? 0,
      idProduk: json['id_produk'] ?? 0,
      // Menggunakan double.tryParse tetap merupakan praktik yang baik untuk keamanan tipe
      energi: double.tryParse(json['energi'].toString()) ?? 0.0,
      lemak: double.tryParse(json['lemak'].toString()) ?? 0.0,
      protein: double.tryParse(json['protein'].toString()) ?? 0.0,
      karbohidrat: double.tryParse(json['karbohidrat'].toString()) ?? 0.0,
      gula: double.tryParse(json['gula'].toString()) ?? 0.0,
      garam: double.tryParse(json['garam'].toString()) ?? 0.0,
    );
  }
}
