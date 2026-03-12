class CrateMaster {
  final String id;
  final String crateCode;
  final double capacityKg;
  final String status;

  CrateMaster({
    required this.id,
    required this.crateCode,
    required this.capacityKg,
    required this.status,
  });

  factory CrateMaster.fromJson(Map<String, dynamic> json) {
    return CrateMaster(
      id: json['id'], // 🔥 REQUIRED
      crateCode: json['crate_code'],
      capacityKg: (json['capacity_kg'] as num).toDouble(),
      status: json['status'],
    );
  }
}
