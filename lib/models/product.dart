class Product {
  final String id;
  final String name;
  final String category;
  final double sugarPer100g;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.sugarPer100g,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id_produk'].toString(), 
      name: json['nama_produk'],        
      category: json['kategori'],         
      sugarPer100g: (json['kadar_gula'] as num).toDouble(), 
    );
  }
}