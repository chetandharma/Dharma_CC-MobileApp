class CollectionCenterModel {
  final String id;
  final String code;
  final String name;

  CollectionCenterModel({
    required this.id,
    required this.code,
    required this.name,
  });

  factory CollectionCenterModel.fromMap(Map<String, dynamic> json) {
    return CollectionCenterModel(
      id: json['id']?.toString() ?? '',
      code: json['center_code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
