class PostModel {
  final String username;
  final String userImage;
  final String content;
  final String imageUrl;
  final DateTime date;
  final int likes;
  final int comments;
  final String? location; // Optional for location posts
  final bool isMap;

  PostModel({
    required this.username,
    required this.userImage,
    required this.content,
    required this.imageUrl,
    required this.date,
    required this.likes,
    required this.comments,
    this.location,
    this.isMap = false,
  });
}
