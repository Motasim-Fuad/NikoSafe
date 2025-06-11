class TheraphySessionModel {
  final String name;
  final String price;
  final String imageUrl;
  final String time;
  final String weekend;
  final bool isAvailable;

  TheraphySessionModel({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
    required this.time,
    required this.weekend,
  });
}
