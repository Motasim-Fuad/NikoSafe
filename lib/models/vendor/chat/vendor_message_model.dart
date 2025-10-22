// Path: models/vendor/chat/vendor_message_model.dart
import 'dart:io';

enum VendorMessageType { text, image, video, file, location }
enum VendorMessageStatus { sending, sent, delivered, read, failed }

class VendorChatMessage {
  final int id;
  final int userId;
  final int vendorId;
  final int senderId;
  final String senderEmail;
  final String senderName;
  final String? text;
  final String? file;
  final String? fileUrl;
  final VendorMessageType messageType;
  final int? replyTo;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSentByMe;
  final VendorMessageStatus status;
  final String? errorMessage;
  final File? localFile;

  VendorChatMessage({
    required this.id,
    required this.userId,
    required this.vendorId,
    required this.senderId,
    required this.senderEmail,
    required this.senderName,
    this.text,
    this.file,
    this.fileUrl,
    required this.messageType,
    this.replyTo,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    required this.isSentByMe,
    this.status = VendorMessageStatus.sent,
    this.errorMessage,
    this.localFile,
  });

  // Safe extraction helpers
  static int _extractInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    if (value is Map && value['id'] != null) {
      return _extractInt(value['id'], defaultValue: defaultValue);
    }
    return defaultValue;
  }

  static String _extractString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
  }

  // Main factory constructor for vendor API response
  factory VendorChatMessage.fromVendorJson(
      Map<String, dynamic> json,
      int currentUserId, {
        String? baseUrl,
      }) {
    // Extract IDs safely
    final userId = _extractInt(json['user']);
    final vendorId = _extractInt(json['vendor']);
    final senderId = _extractInt(json['sender']);

    // Determine if message is sent by current user
    final isSentByMe = senderId == currentUserId;

    // Parse message type
    VendorMessageType messageType = VendorMessageType.text;
    final typeString = json['message_type']?.toString().toLowerCase();
    if (typeString != null) {
      switch (typeString) {
        case 'image':
          messageType = VendorMessageType.image;
          break;
        case 'video':
          messageType = VendorMessageType.video;
          break;
        case 'file':
          messageType = VendorMessageType.file;
          break;
        case 'location':
          messageType = VendorMessageType.location;
          break;
        default:
          messageType = VendorMessageType.text;
      }
    }

    // Parse dates
    DateTime createdAt;
    try {
      createdAt = DateTime.parse(json['created_at']);
    } catch (e) {
      createdAt = DateTime.now();
    }

    DateTime updatedAt;
    try {
      updatedAt = DateTime.parse(json['updated_at']);
    } catch (e) {
      updatedAt = createdAt;
    }

    // Build file URL if needed
    String? fullFileUrl;
    if (json['file_url'] != null) {
      final fileUrl = json['file_url'].toString();
      if (fileUrl.startsWith('http')) {
        fullFileUrl = fileUrl;
      } else if (baseUrl != null) {
        fullFileUrl = '$baseUrl$fileUrl';
      } else {
        fullFileUrl = fileUrl;
      }
    }

    return VendorChatMessage(
      id: _extractInt(json['id']),
      userId: userId,
      vendorId: vendorId,
      senderId: senderId,
      senderEmail: _extractString(json['sender_email']),
      senderName: _extractString(json['sender_name']),
      text: json['text']?.toString(),
      file: json['file']?.toString(),
      fileUrl: fullFileUrl,
      messageType: messageType,
      replyTo: json['reply_to'] != null ? _extractInt(json['reply_to']) : null,
      isRead: json['is_read'] == true,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSentByMe: isSentByMe,
      status: VendorMessageStatus.sent,
    );
  }

  // Copy with method
  VendorChatMessage copyWith({
    int? id,
    VendorMessageStatus? status,
    bool? isRead,
    String? errorMessage,
    String? fileUrl,
  }) {
    return VendorChatMessage(
      id: id ?? this.id,
      userId: userId,
      vendorId: vendorId,
      senderId: senderId,
      senderEmail: senderEmail,
      senderName: senderName,
      text: text,
      file: file,
      fileUrl: fileUrl ?? this.fileUrl,
      messageType: messageType,
      replyTo: replyTo,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSentByMe: isSentByMe,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      localFile: localFile,
    );
  }

  // Convert to JSON for WebSocket
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'vendor': vendorId,
      'sender': senderId,
      'sender_email': senderEmail,
      'sender_name': senderName,
      'text': text,
      'file': file,
      'file_url': fileUrl,
      'message_type': messageType.toString().split('.').last,
      'reply_to': replyTo,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Display text for UI
  String get displayText {
    if (text != null && text!.isNotEmpty) return text!;
    switch (messageType) {
      case VendorMessageType.image:
        return '📷 Image';
      case VendorMessageType.video:
        return '🎥 Video';
      case VendorMessageType.file:
        return '📎 File';
      case VendorMessageType.location:
        return '📍 Location';
      default:
        return '';
    }
  }

  // Time formatting
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[createdAt.weekday - 1];
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  // Check if message is today
  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  // Get full image URL
  String? get fullImageUrl {
    if (messageType == VendorMessageType.image && fileUrl != null) {
      return fileUrl;
    }
    return null;
  }

  // Get full video URL
  String? get fullVideoUrl {
    if (messageType == VendorMessageType.video && fileUrl != null) {
      return fileUrl;
    }
    return null;
  }

  // Check if message has file
  bool get hasFile => fileUrl != null || localFile != null;

  // Get status icon
  String get statusIcon {
    switch (status) {
      case VendorMessageStatus.sending:
        return '🕐';
      case VendorMessageStatus.sent:
        return '✓';
      case VendorMessageStatus.delivered:
        return '✓✓';
      case VendorMessageStatus.read:
        return '✓✓';
      case VendorMessageStatus.failed:
        return '✗';
    }
  }

  @override
  String toString() {
    return 'VendorChatMessage(id: $id, text: $text, isSentByMe: $isSentByMe, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VendorChatMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}