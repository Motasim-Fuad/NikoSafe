class VendorSubscriptionModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final bool isAnnual;
  final bool isMonthly;
  final bool isQuarterly;

  VendorSubscriptionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.isAnnual = false,
    this.isMonthly = false,
    this.isQuarterly = false,
  });
}
