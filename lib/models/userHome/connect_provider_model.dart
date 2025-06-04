class ConnectProvider {
  final String name;
  final String imageUrl;
  final String type;
  final List<String> postedImage;
  final int postCount;
  final int connectCount;

  ConnectProvider({
    required this.name,
    required this.imageUrl,
    required this.type,
    required this.postedImage,
    required this.postCount,
    required this.connectCount,
  });

  factory ConnectProvider.fromJson(Map<String, dynamic> json) {
    return ConnectProvider(
      name: json['name'],
      imageUrl: json['imageUrl'],
      type: json['type'],
      postedImage: List<String>.from(json['postedImage']),
      postCount: json['postCount'] ?? 0,
      connectCount: json['connectCount'] ?? 0,
    );
  }


  Map<String, dynamic> toJson() => {
    'name': name,
    'imageUrl': imageUrl,
    'type': type,
    'postedImage':postedImage,
    'postCount':postCount,
    'connectCount':connectCount,
  };
}
