class VendorPaymentModel {
  final double amount;
  final DateTime date;
  final String transactionId;
  final String accountName;

  VendorPaymentModel({
    required this.amount,
    required this.date,
    required this.transactionId,
    required this.accountName,
  });
}