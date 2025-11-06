class Produk {
  // Info Utama
  final int id;
  final String productName;
  final String kategori;
  final String? gambarUrl;
  final String? barcodeUrl;
  final String? barcodeId; // Kolom barcode_id dari DB

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
    required this.productName,
    required this.kategori,
    this.gambarUrl,
    this.barcodeUrl,
    this.barcodeId,
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

  factory Produk.fromJson(Map<String, dynamic> json) {
    double _parseToDouble(dynamic value) => double.tryParse(value.toString()) ?? 0.0;
    String _parseToString(dynamic value) => value?.toString() ?? '-';

    return Produk(
      // Info Utama - Membaca nama kolom dari DB
      id: json['id_produk'] ?? 0,
      productName: _parseToString(json['product_name']),
      kategori: _parseToString(json['manufacturer']), // Sesuai DB
      gambarUrl: json['image_product_link'], // Sesuai DB
      barcodeUrl: json['barcode_url'], // Sesuai DB
      barcodeId: _parseToString(json['barcode_id']), // Sesuai DB

      // Komposisi Utama - Membaca nama kolom dari DB
      energi: _parseToDouble(json['total_calories']),
      lemak: _parseToDouble(json['total_fat']),
      protein: _parseToDouble(json['protein']),
      karbohidrat: _parseToDouble(json['total_carbohydrates']),
      gula: _parseToDouble(json['total_sugar']),
      garam: _parseToDouble(json['salt_mg']),

      // Jumlah Rinci - Membaca nama kolom dari DB
      lemakTotalJumlah: _parseToString(json['lemak_total_jumlah']),
      kolesterolJumlah: _parseToString(json['kolesterol_jumlah']),
      lemakJenuhJumlah: _parseToString(json['lemak_jenuh_jumlah']),
      proteinRinciJumlah: _parseToString(json['protein_rinci_jumlah']),
      karbohidratTotalJumlah: _parseToString(json['karbohidrat_total_jumlah']),
      seratPanganJumlah: _parseToString(json['serat_pangan_jumlah']),
      gulaRinciJumlah: _parseToString(json['gula_rinci_jumlah']),
      natriumJumlah: _parseToString(json['natrium_jumlah']),

      // % AKG Rinci - Membaca nama kolom dari DB
      persenAkgLemakTotal: _parseToString(json['persen_akg_lemak_total']),
      persenAkgKolesterol: _parseToString(json['persen_akg_kolesterol']),
      persenAkgLemakJenuh: _parseToString(json['persen_akg_lemak_jenuh']),
      persenAkgProtein: _parseToString(json['persen_akg_protein']),
      persenAkgKarbohidratTotal: _parseToString(json['persen_akg_karbohidrat_total']),
      persenAkgSeratPangan: _parseToString(json['persen_akg_serat_pangan']),
      persenAkgGula: _parseToString(json['persen_akg_gula']),
      persenAkgNatrium: _parseToString(json['persen_akg_natrium']),
    );
  }
}
