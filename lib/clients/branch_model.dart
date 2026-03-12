class BranchModel {
  final String id;
  final String clientId;
  final String branchName;
  final String branchCode;

  BranchModel({
    required this.id,
    required this.clientId,
    required this.branchName,
    required this.branchCode,
  });

  factory BranchModel.fromMap(Map<String, dynamic> map) {
    return BranchModel(
      id: map['id'],
      clientId: map['client_id'],
      branchName: map['branch_name'],
      branchCode: map['branch_code'],
    );
  }
}