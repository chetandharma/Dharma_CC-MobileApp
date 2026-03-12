class GrnModel {
  final String grnId;
  final String grnNo;
  final String farmerCode;
  final String centerCode;
  final DateTime grnDate;
  final double totalQuantity;
  final String paymentStatus;

  GrnModel({
    required this.grnId,
    required this.grnNo,
    required this.farmerCode,
    required this.centerCode,
    required this.grnDate,
    required this.totalQuantity,
    required this.paymentStatus,
  });

  factory GrnModel.fromJson(Map<String, dynamic> json) {
    return GrnModel(
      grnId: json['id']?.toString() ?? '',
      grnNo: json['grn_no']?.toString() ?? '',
      farmerCode: json['farmer_code']?.toString() ?? '',
      centerCode: json['center_code']?.toString() ?? '',
      grnDate: json['grn_date'] != null
          ? DateTime.parse(json['grn_date'])
          : DateTime.now(),
      totalQuantity: (json['total_quantity'] ?? 0).toDouble(),
      paymentStatus: json['payment_status']?.toString() ?? 'UNPAID',
    );
  }

}
