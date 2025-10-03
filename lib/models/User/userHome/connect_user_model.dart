// Path: models/User/userHome/connect_user_model.dart

class ConnectUser {
  final int id;
  final String email;
  final String name;
  final String? profilePicture;
  final String friendshipStatus;
  final int totalFriends;
  final int totalPosts;
  final List<int> postIds;
  final int points;
  final int connectPercentage;

  // New fields for chat
  final String? lastMessage;
  final String? lastMessageTime;
  final bool? lastMessageByMe;

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
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageByMe,
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
      postIds: (json['post_ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
      points: json['points'] ?? 0,
      connectPercentage: json['connect_percentage'] ?? 0,
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'],
      lastMessageByMe: json['last_message_by_me'],
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
    'last_message': lastMessage,
    'last_message_time': lastMessageTime,
    'last_message_by_me': lastMessageByMe,
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
    return postIds.map((id) => 'assets/images/post_$id.png').toList();
  }

  String get type => 'User';

  // Helper method to format time for chat list
  String get formattedTime {
    if (lastMessageTime == null) return '';

    try {
      final messageTime = DateTime.parse(lastMessageTime!);
      final now = DateTime.now();
      final difference = now.difference(messageTime);

      if (difference.inDays == 0) {
        // Today - show time
        return '${messageTime.hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        // This week - show day name
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return days[messageTime.weekday - 1];
      } else {
        // Older - show date
        return '${messageTime.day}/${messageTime.month}';
      }
    } catch (e) {
      return '';
    }
  }

  // Copy with method for updating fields
  ConnectUser copyWith({
    String? lastMessage,
    String? lastMessageTime,
    bool? lastMessageByMe,
  }) {
    return ConnectUser(
      id: id,
      email: email,
      name: name,
      profilePicture: profilePicture,
      friendshipStatus: friendshipStatus,
      totalFriends: totalFriends,
      totalPosts: totalPosts,
      postIds: postIds,
      points: points,
      connectPercentage: connectPercentage,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageByMe: lastMessageByMe ?? this.lastMessageByMe,
    );
  }
}