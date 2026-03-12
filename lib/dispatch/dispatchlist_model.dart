class DispatchCrateList {
  final String id;
   String? grnId;
  final String? qrCode;
  final String? crateCode;
  final double totalQty;
  final double remainingQty;
  final String? status;
  final DateTime? createdAt;

  DispatchCrateList({
    required this.id,
    this.grnId,
    this.qrCode,
    this.crateCode,
    required this.totalQty,
    required this.remainingQty,
     this.status,
     this.createdAt,
  });

  factory DispatchCrateList.fromMap(Map<String, dynamic> e) {
    return DispatchCrateList(
      id: e['id'],
      grnId: e['grn_id'],
      qrCode: e['qr_code'],
      crateCode: e['crate_code'],
      totalQty: (e['total_quantity_kg'] as num).toDouble(),
      remainingQty: (e['remaining_quantity_kg'] as num).toDouble(),
      status: e['status'],
      createdAt: DateTime.parse(e['created_at']),
    );
  }
}