// Path: models/User/ChatModel/message_model.dart
import 'dart:io';

enum MessageType {
  text,
  image,
  video,
  location,
  file,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

class ChatMessage {
  final int? id;
  final int senderId;
  final int receiverId;
  final String? text;
  final MessageType type;
  final MessageStatus status;
  final DateTime timestamp;
  final bool isSentByMe;

  // For files
  final String? fileUrl;
  final String? fileName;
  final String? fileType;
  final int? fileSize;

  // For location
  final double? latitude;
  final double? longitude;
  final String? locationName;

  // For local files before upload
  final File? localFile;

  // For UI
  final String? errorMessage;

  ChatMessage({
    this.id,
    required this.senderId,
    required this.receiverId,
    this.text,
    required this.type,
    required this.status,
    required this.timestamp,
    required this.isSentByMe,
    this.fileUrl,
    this.fileName,
    this.fileType,
    this.fileSize,
    this.latitude,
    this.longitude,
    this.locationName,
    this.localFile,
    this.errorMessage,
  });

  // From WebSocket/API JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json, int currentUserId) {
    MessageType messageType = MessageType.text;

    // Check for location first
    if (json['latitude'] != null && json['longitude'] != null) {
      messageType = MessageType.location;
    }
    // Then check file type
    else if (json['message_type'] != null || json['file_type'] != null) {
      final type = (json['message_type'] ?? json['file_type']).toString().toLowerCase();
      if (type.contains('image')) {
        messageType = MessageType.image;
      } else if (type.contains('video')) {
        messageType = MessageType.video;
      } else if (type != 'text') {
        messageType = MessageType.file;
      }
    }
    // Check if file URL exists
    else if (json['file'] != null || json['file_url'] != null) {
      final fileUrl = (json['file'] ?? json['file_url']).toString().toLowerCase();
      if (fileUrl.contains('.jpg') || fileUrl.contains('.png') || fileUrl.contains('.jpeg')) {
        messageType = MessageType.image;
      } else if (fileUrl.contains('.mp4') || fileUrl.contains('.mov')) {
        messageType = MessageType.video;
      } else {
        messageType = MessageType.file;
      }
    }

    // Parse timestamp properly
    DateTime parsedTime;
    try {
      final timeString = json['timestamp'] ?? json['created_at'];
      if (timeString != null) {
        parsedTime = DateTime.parse(timeString);
      } else {
        parsedTime = DateTime.now();
      }
    } catch (e) {
      parsedTime = DateTime.now();
    }

    return ChatMessage(
      id: json['id'],
      senderId: json['sender']?['id'] ?? json['sender_id'],
      receiverId: json['receiver']?['id'] ?? json['receiver_id'],
      text: json['text'] ?? json['message'],
      type: messageType,
      status: MessageStatus.delivered,
      timestamp: parsedTime,
      isSentByMe: (json['sender']?['id'] ?? json['sender_id']) == currentUserId,
      fileUrl: json['file'] ?? json['file_url'],
      fileName: json['file_name'],
      fileType: json['file_type'] ?? json['message_type'],
      fileSize: json['file_size'],
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      locationName: json['location_name'],
    );
  }

  // To WebSocket JSON (for sending)
  Map<String, dynamic> toJson() {
    return {
      'type': 'send_message',
      'receiver_id': receiverId,
      if (text != null && text!.isNotEmpty) 'message': text,
      if (fileUrl != null) 'file_url': fileUrl,
      if (fileName != null) 'file_name': fileName,
      if (fileType != null) 'file_type': fileType,
      if (latitude != null) 'latitude': latitude.toString(),
      if (longitude != null) 'longitude': longitude.toString(),
      if (locationName != null) 'location_name': locationName,
    };
  }

  // Create a copy with updated fields
  ChatMessage copyWith({
    int? id,
    MessageStatus? status,
    String? fileUrl,
    String? errorMessage,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      type: type,
      status: status ?? this.status,
      timestamp: timestamp,
      isSentByMe: isSentByMe,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName,
      fileType: fileType,
      fileSize: fileSize,
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
      localFile: localFile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Get display text for message
  String get displayText {
    switch (type) {
      case MessageType.text:
        return text ?? '';
      case MessageType.image:
        return '📷 Image';
      case MessageType.video:
        return '🎥 Video';
      case MessageType.file:
        return '📎 ${fileName ?? 'File'}';
      case MessageType.location:
        return '📍 ${locationName ?? 'Location'}';
    }
  }

  // Get location URL for maps
  String? get locationUrl {
    if (latitude != null && longitude != null) {
      return 'https://maps.google.com/?q=$latitude,$longitude';
    }
    return null;
  }
}