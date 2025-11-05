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

  factory Produk.fromJson(Map<String, dynamic> json) {
    // Helper untuk parsing double dengan aman
    double parseDouble(dynamic value) => double.tryParse(value.toString()) ?? 0.0;

    return Produk(
      // Info Utama
      id: json['id_produk'] ?? 0,
      namaProduk: json['nama_produk'] ?? 'Tanpa Nama',
      kategori: json['kategori'] ?? 'Tanpa Kategori',
      gambarUrl: json['gambar_url'],
      barcodeUrl: json['barcode_url'],

      // Komposisi Utama
      energi: parseDouble(json['energi']),
      lemak: parseDouble(json['lemak']),
      protein: parseDouble(json['protein']),
      karbohidrat: parseDouble(json['karbohidrat']),
      gula: parseDouble(json['gula']),
      garam: parseDouble(json['garam']),

      // Jumlah Rinci
      lemakTotalJumlah: json['lemak_total_jumlah'] ?? '-',
      kolesterolJumlah: json['kolesterol_jumlah'] ?? '-',
      lemakJenuhJumlah: json['lemak_jenuh_jumlah'] ?? '-',
      proteinRinciJumlah: json['protein_rinci_jumlah'] ?? '-',
      karbohidratTotalJumlah: json['karbohidrat_total_jumlah'] ?? '-',
      seratPanganJumlah: json['serat_pangan_jumlah'] ?? '-',
      gulaRinciJumlah: json['gula_rinci_jumlah'] ?? '-',
      natriumJumlah: json['natrium_jumlah'] ?? '-',

      // % AKG Rinci
      persenAkgLemakTotal: json['persen_akg_lemak_total'] ?? '-',
      persenAkgKolesterol: json['persen_akg_kolesterol'] ?? '-',
      persenAkgLemakJenuh: json['persen_akg_lemak_jenuh'] ?? '-',
      persenAkgProtein: json['persen_akg_protein'] ?? '-',
      persenAkgKarbohidratTotal: json['persen_akg_karbohidrat_total'] ?? '-',
      persenAkgSeratPangan: json['persen_akg_serat_pangan'] ?? '-',
      persenAkgGula: json['persen_akg_gula'] ?? '-',
      persenAkgNatrium: json['persen_akg_natrium'] ?? '-',
    );
  }
}
