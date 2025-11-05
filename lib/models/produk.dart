class Produk {
  final int id;
  final String namaProduk;
  final String kategori;
  final String? gambarUrl; // TAMBAHAN: Kolom untuk URL gambar, boleh null

  Produk({
    required this.id,
    required this.namaProduk,
    required this.kategori,
    this.gambarUrl,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id_produk'] ?? 0, 
      namaProduk: json['nama_produk'] ?? 'Tanpa Nama',
      kategori: json['kategori'] ?? 'Tanpa Kategori',
      // TAMBAHAN: Mengambil data URL gambar dari JSON
      gambarUrl: json['gambar_url'], 
    );
  }
}
