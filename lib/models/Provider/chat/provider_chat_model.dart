import 'package:nikosafe/resource/App_Url/app_url.dart';

class ServiceChatModel {
  final int id; // ✅ For PROVIDER: user_id | For USER: provider_id
  final int? conversationId; // ✅ Store conversation ID separately
  final String name;
  final String email;
  final String? profilePicture;
  final String? designation;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final bool? lastMessageByMe;

  ServiceChatModel({
    required this.id,
    this.conversationId,
    required this.name,
    required this.email,
    this.profilePicture,
    this.designation,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.lastMessageByMe,
  });

  // ✅ Full image URL
  String get imageUrl {
    if (profilePicture == null || profilePicture!.isEmpty) {
      return '';
    }
    if (profilePicture!.startsWith('http')) {
      return profilePicture!;
    }
    return '${AppUrl.base_url}$profilePicture';
  }

  // ✅ Formatted time
  String get formattedTime {
    if (lastMessageTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(lastMessageTime!);

    if (difference.inDays == 0) {
      final hours = lastMessageTime!.hour;
      final minutes = lastMessageTime!.minute;
      final period = hours >= 12 ? 'PM' : 'AM';
      final displayHour = hours > 12 ? hours - 12 : (hours == 0 ? 12 : hours);
      return '$displayHour:${minutes.toString().padLeft(2, '0')} $period';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${lastMessageTime!.day}/${lastMessageTime!.month}/${lastMessageTime!.year}';
    }
  }

  factory ServiceChatModel.fromJson(Map<String, dynamic> json) {
    // Parse last message time
    DateTime? lastMsgTime;
    if (json['last_message_at'] != null) {
      try {
        lastMsgTime = DateTime.parse(json['last_message_at']);
      } catch (e) {
        lastMsgTime = null;
      }
    }

    // Also try from last_message object
    if (lastMsgTime == null && json['last_message'] != null && json['last_message'] is Map) {
      try {
        lastMsgTime = DateTime.parse(json['last_message']['created_at'] ?? '');
      } catch (e) {
        lastMsgTime = null;
      }
    }

    // ✅ Handle nested Maps safely
    String? extractString(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is Map && value.containsKey('url')) return value['url']?.toString();
      if (value is Map && value.containsKey('text')) return value['text']?.toString();
      return value.toString();
    }

    // Extract last message text
    String? lastMessageText;
    if (json['last_message'] != null && json['last_message'] is Map) {
      lastMessageText = extractString(json['last_message']['text']);
    } else {
      lastMessageText = extractString(json['last_message']);
    }

    // Extract user ID
    final int userId = json['user'] ?? 0;
    final int conversationId = json['id'] ?? 0;

    // ✅ For provider view, we need to get user information
    // Since your API doesn't provide user names, we'll use a default format
    String userName = 'User #$userId'; // Default format: User #40, User #100, etc.
    String userEmail = 'user$userId@example.com'; // Default email

    // Try to extract from last_message sender if it's the user
    if (json['last_message'] != null && json['last_message'] is Map) {
      final lastMsg = json['last_message'] as Map;
      final senderId = lastMsg['sender'];

      // If the sender is the user (not the provider), use their info
      if (senderId == userId) {
        userName = lastMsg['sender_name']?.toString() ?? 'User #$userId';
        userEmail = lastMsg['sender_email']?.toString() ?? 'user$userId@example.com';
      }
    }

    return ServiceChatModel(
      id: userId, // ✅ This is the USER ID that provider wants to chat with
      conversationId: conversationId,
      name: userName,
      email: userEmail,
      profilePicture: extractString(json['user_profile_picture'] ?? json['profile_picture']),
      designation: extractString(json['designation']),
      lastMessage: lastMessageText,
      lastMessageTime: lastMsgTime,
      unreadCount: json['unread_count_provider'] ?? json['unread_count'] ?? 0,
      lastMessageByMe: json['last_message_by_me'],
    );
  }

  // ✅ Update copyWith method
  ServiceChatModel copyWith({
    int? id,
    int? conversationId,
    String? name,
    String? email,
    String? profilePicture,
    String? designation,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    bool? lastMessageByMe,
  }) {
    return ServiceChatModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      designation: designation ?? this.designation,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessageByMe: lastMessageByMe ?? this.lastMessageByMe,
    );
  }

  @override
  String toString() {
    return 'ServiceChatModel(id: $id, name: $name, email: $email, lastMessage: $lastMessage)';
  }
}