class CrateAssignmentModel {
  final String? id;
  final String? grnId;
  final String? crateId;
  final String? crateCode;
  final String? packerCode;

  final int? bagSizeKg;
  final int? bagCount;

  final DateTime? startedAt;
  final DateTime? finishedAt;
  final DateTime? createdAt;

  final String? status;
  final String? note;

  CrateAssignmentModel({
    this.id,
    this.grnId,
    this.crateId,
    this.crateCode,
    this.packerCode,
    this.bagSizeKg,
    this.bagCount,
    this.startedAt,
    this.finishedAt,
    this.createdAt,
    this.status,
    this.note,
  });

  factory CrateAssignmentModel.fromJson(Map<String, dynamic> json) {
    return CrateAssignmentModel(
      id: json['id'] as String?,
      grnId: json['grn_id'] as String?,
      crateId: json['crate_id'] as String?,
      crateCode: json['crate_code'] as String?,
      packerCode: json['packer_code'] as String?,

      bagSizeKg: json['bag_size_kg'] as int?,
      bagCount: json['bag_count'] as int?,

      startedAt: json['started_at'] == null
          ? null
          : DateTime.parse(json['started_at']),

      finishedAt: json['finished_at'] == null
          ? null
          : DateTime.parse(json['finished_at']),

      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at']),

      status: json['status'] as String?,
      note: json['note'] as String?,
    );
  }

  /// ⏱ Packing duration
  Duration? get packingDuration {
    if (startedAt == null || finishedAt == null) return null;
    return finishedAt!.difference(startedAt!);
  }
}


// class CrateAssignmentModel {
//   final String id;
//   final String grnId;
//   final String crateCode;
//   final String packerCode;
//   final int bagSize;
//   final int bagCount;
//   final DateTime createdAt;
//
//   CrateAssignmentModel({
//     required this.id,
//     required this.grnId,
//     required this.crateCode,
//     required this.packerCode,
//     required this.bagSize,
//     required this.bagCount,
//     required this.createdAt,
//   });
//
//   factory CrateAssignmentModel.fromJson(Map<String, dynamic> json) {
//     return CrateAssignmentModel(
//       id: json['id'],
//       grnId: json['grn_id'],
//       crateCode: json['crate_code'],
//       packerCode: json['packer_code'],
//       bagSize: json['bag_size_kg'],
//       bagCount: json['bag_count'],
//       createdAt: DateTime.parse(json['created_at']),
//     );
//   }
// }
