class Produk {
  // Info Utama
  final int id;
  final String namaProduk;
  final String kategori;
  final String? gambarUrl;
  final String? barcodeUrl;

  // Komposisi Utama (untuk progress bar)
  final double energi;
  final double lemak;
  final double protein;
  final double karbohidrat;
  final double gula;
  final double garam;

  // Tabel Nilai Gizi Rinci (Jumlah)
  final String lemakTotalJumlah;
  final String kolesterolJumlah;
  final String lemakJenuhJumlah;
  final String proteinRinciJumlah;
  final String karbohidratTotalJumlah;
  final String seratPanganJumlah;
  final String gulaRinciJumlah;
  final String natriumJumlah;

  // Tabel Nilai Gizi Rinci (% AKG)
  final String persenAkgLemakTotal;
  final String persenAkgKolesterol;
  final String persenAkgLemakJenuh;
  final String persenAkgProtein;
  final String persenAkgKarbohidratTotal;
  final String persenAkgSeratPangan;
  final String persenAkgGula;
  final String persenAkgNatrium;

  Produk({
    required this.id,
    required this.namaProduk,
    required this.kategori,
    this.gambarUrl,
    this.barcodeUrl,
    required this.energi,
    required this.lemak,
    required this.protein,
    required this.karbohidrat,
    required this.gula,
    required this.garam,
    required this.lemakTotalJumlah,
    required this.kolesterolJumlah,
    required this.lemakJenuhJumlah,
    required this.proteinRinciJumlah,
    required this.karbohidratTotalJumlah,
    required this.seratPanganJumlah,
    required this.gulaRinciJumlah,
    required this.natriumJumlah,
    required this.persenAkgLemakTotal,
    required this.persenAkgKolesterol,
    required this.persenAkgLemakJenuh,
    required this.persenAkgProtein,
    required this.persenAkgKarbohidratTotal,
    required this.persenAkgSeratPangan,
    required this.persenAkgGula,
    required this.persenAkgNatrium,
  });

  // Factory constructor untuk membuat instance dari JSON
  factory Produk.fromJson(Map<String, dynamic> json) {
    // Helper untuk parsing, memberikan nilai default jika null
    double _parseToDouble(dynamic value) => double.tryParse(value.toString()) ?? 0.0;
    String _parseToString(dynamic value) => value?.toString() ?? '-';

    return Produk(
      // Info Utama
      id: json['id_produk'] ?? 0,
      namaProduk: _parseToString(json['product_name']),
      kategori: _parseToString(json['kategori']),
      gambarUrl: json['gambarUrl'], // Kunci JSON sudah sesuai
      barcodeUrl: json['barcodeUrl'], // Kunci JSON sudah sesuai

      // Komposisi Utama (diterjemahkan dari JSON)
      energi: _parseToDouble(json['energi']),
      lemak: _parseToDouble(json['lemak']),
      protein: _parseToDouble(json['protein']),
      karbohidrat: _parseToDouble(json['karbohidrat']),
      gula: _parseToDouble(json['gula']),
      garam: _parseToDouble(json['garam']),

      // Jumlah Rinci
      lemakTotalJumlah: _parseToString(json['lemakTotalJumlah']),
      kolesterolJumlah: _parseToString(json['kolesterolJumlah']),
      lemakJenuhJumlah: _parseToString(json['lemakJenuhJumlah']),
      proteinRinciJumlah: _parseToString(json['proteinRinciJumlah']),
      karbohidratTotalJumlah: _parseToString(json['karbohidratTotalJumlah']),
      seratPanganJumlah: _parseToString(json['seratPanganJumlah']),
      gulaRinciJumlah: _parseToString(json['gulaRinciJumlah']),
      natriumJumlah: _parseToString(json['natriumJumlah']),

      // % AKG Rinci
      persenAkgLemakTotal: _parseToString(json['persenAkgLemakTotal']),
      persenAkgKolesterol: _parseToString(json['persenAkgKolesterol']),
      persenAkgLemakJenuh: _parseToString(json['persenAkgLemakJenuh']),
      persenAkgProtein: _parseToString(json['persenAkgProtein']),
      persenAkgKarbohidratTotal: _parseToString(json['persenAkgKarbohidratTotal']),
      persenAkgSeratPangan: _parseToString(json['persenAkgSeratPangan']),
      persenAkgGula: _parseToString(json['persenAkgGula']),
      persenAkgNatrium: _parseToString(json['persenAkgNatrium']),
    );
  }
}
