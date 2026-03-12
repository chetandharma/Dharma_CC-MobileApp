class PackingRecord {
  final String crateNo;
  String packerName;
  DateTime packedAt;
  String condition; // OK / Loose / Damaged

  PackingRecord({
    required this.crateNo,
    required this.packerName,
    required this.packedAt,
    required this.condition,
  });
}
