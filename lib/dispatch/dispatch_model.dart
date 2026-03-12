class DispatchCrateListModel {
  final String id;
  final String? crateCode;
  final String? qrCode;
  final String? grnId;
  final double remainingQty;

  bool isSelected;
  double dispatchQty;

  DispatchCrateListModel({
    required this.id,
    this.crateCode,
    this.qrCode,
    this.grnId,
    required this.remainingQty,
    this.isSelected = false,
    this.dispatchQty = 0,
  });

  factory DispatchCrateListModel.fromMap(Map<String, dynamic> json) {
    return DispatchCrateListModel(
      id: json['id'],
      crateCode: json['crate_code'],
      qrCode: json['qr_code'],
      grnId: json['grn_id'],
      remainingQty:
      (json['remaining_quantity_kg'] as num).toDouble(),
    );
  }
}