class NilaiGiziRinci {
  final int id;
  final int idProduk;
  final String namaGizi;
  final String jumlah;
  final String persenAkg;

  NilaiGiziRinci({
    required this.id,
    required this.idProduk,
    required this.namaGizi,
    required this.jumlah,
    required this.persenAkg,
  });

  factory NilaiGiziRinci.fromJson(Map<String, dynamic> json) {
    return NilaiGiziRinci(
      id: json['id_nilai_gizi'] ?? 0,
      idProduk: json['id_produk'] ?? 0,
      namaGizi: json['nama_gizi'] ?? '-',
      jumlah: json['jumlah'] ?? '-',
      persenAkg: json['persen_akg'] ?? '-',
    );
  }
}
