class FarmerModel {
  final String id;
  final String name;
  final String? phone;
  final double rating;
  final String? bankAccount;
  final String? ifsc;
  final bool isActive;
  final String farmerCode;
  final DateTime createdAt;

  FarmerModel({
    required this.id,
    required this.name,
    this.phone,
    required this.rating,
    this.bankAccount,
    this.ifsc,
    required this.isActive,
    required this.farmerCode,
    required this.createdAt,
  });

  factory FarmerModel.fromMap(Map<String, dynamic> json) {
    return FarmerModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      rating: json['rating'] == null
          ? 0.0
          : double.parse(json['rating'].toString()),
      bankAccount: json['bank_account'],
      ifsc: json['ifsc'],
      isActive: json['is_active'] ?? true,
      farmerCode: json['farmer_code'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}