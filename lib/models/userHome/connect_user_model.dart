// Path: models/userHome/connect_user_model.dart
// Copy this ENTIRE file - FIXED for integer post_ids

class ConnectUser {
  final int id;
  final String email;
  final String name;
  final String? profilePicture;
  final String friendshipStatus;
  final int totalFriends;
  final int totalPosts;
  final List<int> postIds; // Changed to List<int>
  final int points;
  final int connectPercentage;

  ConnectUser({
    required this.id,
    required this.email,
    required this.name,
    this.profilePicture,
    required this.friendshipStatus,
    required this.totalFriends,
    required this.totalPosts,
    required this.postIds,
    required this.points,
    required this.connectPercentage,
  });

  factory ConnectUser.fromJson(Map<String, dynamic> json) {
    return ConnectUser(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? 'Unknown',
      profilePicture: json['profile_picture'],
      friendshipStatus: json['friendship_status'] ?? 'not_connected',
      totalFriends: json['total_friends'] ?? 0,
      totalPosts: json['total_posts'] ?? 0,
      postIds: (json['post_ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [], // Proper casting
      points: json['points'] ?? 0,
      connectPercentage: json['connect_percentage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'profile_picture': profilePicture,
    'friendship_status': friendshipStatus,
    'total_friends': totalFriends,
    'total_posts': totalPosts,
    'post_ids': postIds,
    'points': points,
    'connect_percentage': connectPercentage,
  };

  String get imageUrl {
    if (profilePicture != null && profilePicture!.isNotEmpty) {
      if (profilePicture!.startsWith('http')) {
        return profilePicture!;
      }
      return 'https://resolutions-responded-stages-prepare.trycloudflare.com$profilePicture';
    }
    return 'assets/images/peopleProfile4.jpg';
  }

  int get connectCount => totalFriends;
  int get postCount => totalPosts;

  List<String> get postedImage {
    if (postIds.isEmpty) {
      return [];
    }
    // Convert integer post IDs to placeholder image paths
    return postIds.map((id) => 'assets/images/post_$id.png').toList();
  }

  String get type => 'User';
}