class UserPaymentModel {
  final double amount;
  final DateTime date;
  final String transactionId;
  final String accountName;

  UserPaymentModel({
    required this.amount,
    required this.date,
    required this.transactionId,
    required this.accountName,
  });
}