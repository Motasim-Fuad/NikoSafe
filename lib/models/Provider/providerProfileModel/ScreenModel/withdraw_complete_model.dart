class WithdrawCompleteModel {
  final String date;
  final String amount;
  final String status;

  WithdrawCompleteModel({
    required this.date,
    required this.amount,
    required this.status,
  });

  factory WithdrawCompleteModel.fromJson(Map<String, dynamic> json) {
    return WithdrawCompleteModel(
      date: json['date'],
      amount: json['amount'],
      status: json['status'],
    );
  }
}
