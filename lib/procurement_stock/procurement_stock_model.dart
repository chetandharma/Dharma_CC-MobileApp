class ProcurementStock {
  final String? productCode;
  final String qualityGrade;
  final double totalQuantityKg;
  final double avgPricePerKg;

  ProcurementStock({
    required this.productCode,
    required this.qualityGrade,
    required this.totalQuantityKg,
    required this.avgPricePerKg,
  });

  factory ProcurementStock.fromMap(Map<String, dynamic> e) {
    return ProcurementStock(
      productCode: e['product_code'],
      qualityGrade: e['quality_grade'],
      totalQuantityKg: (e['total_quantity_kg'] as num).toDouble(),
      avgPricePerKg: (e['avg_price_per_kg'] as num).toDouble(),
    );
  }
}