class BankDetailModel {
  int? id;
  String accountNumber;
  String routingNumber;
  String bankName;
  String bankHolderName;
  String bankAddress;
  bool? isApproved;

  BankDetailModel({
    this.id,
    required this.accountNumber,
    required this.routingNumber,
    required this.bankName,
    required this.bankHolderName,
    required this.bankAddress,
    this.isApproved,
  });

  factory BankDetailModel.fromJson(Map<String, dynamic> json) {
    return BankDetailModel(
      id: json['id'],
      accountNumber: json['account_number'] ?? '',
      routingNumber: json['routing_number'] ?? '',
      bankName: json['bank_name'] ?? '',
      bankHolderName: json['bank_holder_name'] ?? '',
      bankAddress: json['bank_address'] ?? '',
      isApproved: json['is_approved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'account_number': accountNumber,
    'routing_number': routingNumber,
    'bank_name': bankName,
    'bank_holder_name': bankHolderName,
    'bank_address': bankAddress,
    if (isApproved != null) 'is_approved': isApproved,
  };

  // Copy with method for easy updates
  BankDetailModel copyWith({
    int? id,
    String? accountNumber,
    String? routingNumber,
    String? bankName,
    String? bankHolderName,
    String? bankAddress,
    bool? isApproved,
  }) {
    return BankDetailModel(
      id: id ?? this.id,
      accountNumber: accountNumber ?? this.accountNumber,
      routingNumber: routingNumber ?? this.routingNumber,
      bankName: bankName ?? this.bankName,
      bankHolderName: bankHolderName ?? this.bankHolderName,
      bankAddress: bankAddress ?? this.bankAddress,
      isApproved: isApproved ?? this.isApproved,
    );
  }
}

