class InventoryListModel{
  final String id;
  final double quantityKg;
  final double pricePerKg;
  final String? grnNo;
  final String? productCode;
  final String qualityGrade;
  final DateTime createdAt;

  InventoryListModel({
    required this.id,
    required this.quantityKg,
    required this.pricePerKg,
    this.grnNo,
    this.productCode,
    required this.qualityGrade,
    required this.createdAt,
  });

  factory InventoryListModel.fromMap(Map<String, dynamic> e) {
    return InventoryListModel(
      id: e['id'],
      quantityKg: (e['quantity_kg'] as num).toDouble(),
      pricePerKg: (e['price_per_kg'] as num).toDouble(),
      grnNo: e['grn_no'],
      productCode: e['product_code'],
      qualityGrade: e['quality_grade'],
      createdAt: DateTime.parse(e['created_at']),
    );
  }
}