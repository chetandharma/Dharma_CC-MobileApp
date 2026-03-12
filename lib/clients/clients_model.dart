class ClientModel {
  final String id;
  final String clientName;

  ClientModel({
    required this.id,
    required this.clientName,
  });

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'],
      clientName: map['client_name'],
    );
  }
}