class ProviderEarningDataModel {
  final String serial;
  final String name;
  final String accNumber;
  final String date;
  final String amount;
  final String? avatarUrl;

  ProviderEarningDataModel({
    required this.serial,
    required this.name,
    required this.accNumber,
    required this.date,
    required this.amount,
    this.avatarUrl,
  });

  factory ProviderEarningDataModel.fromJson(Map<String, dynamic> json) {
    return ProviderEarningDataModel(
      serial: json['serial'],
      name: json['name'],
      accNumber: json['accNumber'],
      date: json['date'],
      amount: json['amount'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serial': serial,
      'name': name,
      'accNumber': accNumber,
      'date': date,
      'amount': amount,
      'avatarUrl': avatarUrl,
    };
  }
}
