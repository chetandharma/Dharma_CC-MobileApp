class GrnDispatchCrateModel {
  final String id;
  final String crateCode;
  final int totalQty;
  final String status;

  GrnDispatchCrateModel({
    required this.id,
    required this.crateCode,
    required this.totalQty,
    required this.status,
  });

  factory GrnDispatchCrateModel.fromJson(Map<String, dynamic> json) {
    return GrnDispatchCrateModel(
      id: json['id'],
      crateCode: json['crate_code'] ?? '-',
      totalQty: json['total_qty'] ?? 0,
      status: json['status'] ?? 'pending',
    );
  }
}