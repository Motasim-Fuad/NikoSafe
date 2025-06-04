class ExploreItemModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String location;
  final String date;
  final String time;
  final double rating;
  final String category; // restaurant | bar | club_event

  ExploreItemModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.location,
    required this.date,
    required this.time,
    required this.rating,
    required this.category,
  });
}
