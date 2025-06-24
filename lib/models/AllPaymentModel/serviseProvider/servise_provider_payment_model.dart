class ServiseProviderPaymentModel {
  final double amount;
  final DateTime date;
  final String transactionId;
  final String accountName;

  ServiseProviderPaymentModel({
    required this.amount,
    required this.date,
    required this.transactionId,
    required this.accountName,
  });
}