class Product {
  final int id;
  final String name;
  final int? calories;
  final double? sugarContent;

  Product({
    required this.id,
    required this.name,
    this.calories,
    this.sugarContent,
  });

  // Factory constructor untuk membuat instance Product dari JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      calories: json['calories'] as int?,
      // Pastikan tipe data dari SQL/JSON cocok
      sugarContent: (json['sugar_content'] as num?)?.toDouble(),
    );
  }
}
