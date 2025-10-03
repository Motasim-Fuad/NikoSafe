class MyProfileDetailsModel {
  final String name;
  final String imageUrl;
  final int posts;
  final int connects;
  final List<String> galleryImages;

  MyProfileDetailsModel({
    required this.name,
    required this.imageUrl,
    required this.posts,
    required this.connects,
    required this.galleryImages,
  });

  factory MyProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    return MyProfileDetailsModel(
      name: json['name'],
      imageUrl: json['imageUrl'],
      posts: json['posts'],
      connects: json['connects'],
      galleryImages: List<String>.from(json['galleryImages']),
    );
  }
}
