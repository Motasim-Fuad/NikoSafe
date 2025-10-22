import 'dart:io';

/// Message content type
enum ServiceProviderMessageType { text, image, video, file, location }

/// Message delivery/read status
enum ServiceProviderMessageStatus { sending, sent, delivered, read, failed }

class ServiceProviderChatMessage {
  final int id;
  final int userId;
  final int providerId;
  final int senderId;
  final String senderEmail;
  final String senderName;
  final String? text;
  final String? file;
  final String? fileUrl;
  final ServiceProviderMessageType messageType;
  final int? replyTo;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSentByMe;
  final ServiceProviderMessageStatus status;
  final String? errorMessage;
  final File? localFile;

  ServiceProviderChatMessage({
    required this.id,
    required this.userId,
    required this.providerId,
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
    this.status = ServiceProviderMessageStatus.sent,
    this.errorMessage,
    this.localFile,
  });

  /// -------- Safe extract helpers ----------
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

  /// -------- Factory for parsing from backend response ----------
  factory ServiceProviderChatMessage.fromJson(
      Map<String, dynamic> json,
      int currentUserId, {
        String? baseUrl,
      }) {
    final userId = _extractInt(json['user']);
    final providerId = _extractInt(json['provider']);
    final senderId = _extractInt(json['sender']);

    // Determine if the message was sent by the logged-in user
    final isSentByMe = senderId == currentUserId;

    // Parse message type safely
    ServiceProviderMessageType messageType = ServiceProviderMessageType.text;
    final typeString = json['message_type']?.toString().toLowerCase();
    if (typeString != null) {
      switch (typeString) {
        case 'image':
          messageType = ServiceProviderMessageType.image;
          break;
        case 'video':
          messageType = ServiceProviderMessageType.video;
          break;
        case 'file':
          messageType = ServiceProviderMessageType.file;
          break;
        case 'location':
          messageType = ServiceProviderMessageType.location;
          break;
        default:
          messageType = ServiceProviderMessageType.text;
      }
    }

    // Parse created and updated times
    DateTime createdAt;
    try {
      createdAt = DateTime.parse(json['created_at']);
    } catch (_) {
      createdAt = DateTime.now();
    }

    DateTime updatedAt;
    try {
      updatedAt = DateTime.parse(json['updated_at']);
    } catch (_) {
      updatedAt = createdAt;
    }

    // Build full file URL
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

    return ServiceProviderChatMessage(
      id: _extractInt(json['id']),
      userId: userId,
      providerId: providerId,
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
      status: ServiceProviderMessageStatus.sent,
    );
  }

  /// -------- Copy With ----------
  ServiceProviderChatMessage copyWith({
    int? id,
    ServiceProviderMessageStatus? status,
    bool? isRead,
    String? errorMessage,
    String? fileUrl,
  }) {
    return ServiceProviderChatMessage(
      id: id ?? this.id,
      userId: userId,
      providerId: providerId,
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

  /// -------- Convert to JSON (for WebSocket / Send API) ----------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'provider': providerId,
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

  /// -------- Display Helpers ----------
  String get displayText {
    if (text != null && text!.isNotEmpty) return text!;
    switch (messageType) {
      case ServiceProviderMessageType.image:
        return '📷 Image';
      case ServiceProviderMessageType.video:
        return '🎥 Video';
      case ServiceProviderMessageType.file:
        return '📎 File';
      case ServiceProviderMessageType.location:
        return '📍 Location';
      default:
        return '';
    }
  }

  /// -------- Time Formatting ----------
  String get formattedTime {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inDays == 0) {
      return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[createdAt.weekday - 1];
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }

  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  bool get hasFile => fileUrl != null || localFile != null;

  String get statusIcon {
    switch (status) {
      case ServiceProviderMessageStatus.sending:
        return '🕐';
      case ServiceProviderMessageStatus.sent:
        return '✓';
      case ServiceProviderMessageStatus.delivered:
        return '✓✓';
      case ServiceProviderMessageStatus.read:
        return '✓✓';
      case ServiceProviderMessageStatus.failed:
        return '✗';
    }
  }

  @override
  String toString() =>
      'ServiceProviderChatMessage(id: $id, text: $text, sentByMe: $isSentByMe, status: $status)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ServiceProviderChatMessage && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
