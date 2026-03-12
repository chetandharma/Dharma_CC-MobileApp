class ProductModel {
  final String id;
  final String code;
  final String name;

  ProductModel({
    required this.id,
    required this.code,
    required this.name,
  });

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      code: json['product_code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
