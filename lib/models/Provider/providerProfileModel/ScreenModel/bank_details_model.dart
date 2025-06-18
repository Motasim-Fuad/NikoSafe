class BankDetailModel {
  String accountNumber;
  String routingNumber;
  String bankName;
  String bankHolderName;
  String bankAddress;

  BankDetailModel({
    required this.accountNumber,
    required this.routingNumber,
    required this.bankName,
    required this.bankHolderName,
    required this.bankAddress,
  });

  factory BankDetailModel.fromJson(Map<String, dynamic> json) {
    return BankDetailModel(
      accountNumber: json['accountNumber'] ?? '',
      routingNumber: json['routingNumber'] ?? '',
      bankName: json['bankName'] ?? '',
      bankHolderName: json['bankHolderName'] ?? '',
      bankAddress: json['bankAddress'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'accountNumber': accountNumber,
    'routingNumber': routingNumber,
    'bankName': bankName,
    'bankHolderName': bankHolderName,
    'bankAddress': bankAddress,
  };
}
