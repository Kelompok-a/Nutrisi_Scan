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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      calories: json['calories'] as int?,
      sugarContent: (json['sugar_content'] as num?)?.toDouble(),
    );
  }
}
