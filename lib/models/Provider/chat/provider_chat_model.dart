class ServiceChatModel {
  final int id;
  final String name;
  final String email;
  final String? profilePicture;
  final String? designation;
  final String? lastMessage;
  final String? lastMessageTime;
  final bool? lastMessageByMe;
  final int unreadCount;

  ServiceChatModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    this.designation,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageByMe,
    this.unreadCount = 0,
  });

  factory ServiceChatModel.fromJson(Map<String, dynamic> json) {
    return ServiceChatModel(
      id: json['id'] ?? json['provider_id'] ?? 0,
      name: json['name'] ?? json['provider_name'] ?? 'Unknown Provider',
      email: json['email'] ?? json['provider_email'] ?? '',
      profilePicture: json['profile_picture'] ?? json['provider_profile_picture'],
      designation: json['designation'],
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'] ?? json['last_message_at'],
      lastMessageByMe: json['last_message_by_me'],
      unreadCount: json['unread_count'] ?? json['unread_count_user'] ?? 0,
    );
  }

  String get imageUrl {
    if (profilePicture != null && profilePicture!.isNotEmpty) {
      if (profilePicture!.startsWith('http')) {
        return profilePicture!;
      }
      return 'https://dangerous-dispatched-numeric-flat.trycloudflare.com$profilePicture';
    }
    return 'assets/images/peopleProfile4.jpg';
  }

  String get formattedTime {
    if (lastMessageTime == null) return '';

    try {
      final messageTime = DateTime.parse(lastMessageTime!);
      final now = DateTime.now();
      final difference = now.difference(messageTime);

      if (difference.inDays == 0) {
        return '${messageTime.hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return days[messageTime.weekday - 1];
      } else {
        return '${messageTime.day}/${messageTime.month}';
      }
    } catch (e) {
      return '';
    }
  }
}