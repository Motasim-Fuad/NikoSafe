class UserSubscriptionModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final bool isAnnual;
  final bool isMonthly;
  final bool isQuarterly;

  UserSubscriptionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.isAnnual = false,
    this.isMonthly = false,
    this.isQuarterly = false,
  });
}
