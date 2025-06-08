class UserHistoryPurchaseModel {
  final String imageUrl;
  final String itemName;
  final String date;
  final String time;
  final double amount;
  final bool isDelivered;

  UserHistoryPurchaseModel({
    required this.imageUrl,
    required this.itemName,
    required this.date,
    required this.time,
    required this.amount,
    required this.isDelivered,
  });
}
