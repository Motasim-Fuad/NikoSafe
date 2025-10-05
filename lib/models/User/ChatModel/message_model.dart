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
  factory ChatMessage.fromJson(Map<String, dynamic> json, int currentUserId, {String? baseUrl}) {
    MessageType messageType = MessageType.text;

    // ✅ Check text for location URL first
    final textContent = json['text'] ?? json['message'];
    if (textContent != null && textContent.toString().contains('maps.google.com')) {
      messageType = MessageType.location;
    }
    // Check for location coordinates
    else if (json['latitude'] != null && json['longitude'] != null) {
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
      if (fileUrl.contains('.jpg') || fileUrl.contains('.png') || fileUrl.contains('.jpeg') || fileUrl.contains('.webp') || fileUrl.contains('.gif')) {
        messageType = MessageType.image;
      } else if (fileUrl.contains('.mp4') || fileUrl.contains('.mov') || fileUrl.contains('.avi')) {
        messageType = MessageType.video;
      } else if (fileUrl.isNotEmpty && fileUrl != 'null') {
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

    // Fix file URL - convert relative path to full URL
    String? fixedFileUrl;
    final rawFileUrl = json['file'] ?? json['file_url'];
    if (rawFileUrl != null && rawFileUrl.toString().isNotEmpty && rawFileUrl.toString() != 'null') {
      final fileUrlStr = rawFileUrl.toString();
      if (fileUrlStr.startsWith('http://') || fileUrlStr.startsWith('https://')) {
        fixedFileUrl = fileUrlStr;
      } else if (fileUrlStr.startsWith('/')) {
        if (baseUrl != null) {
          fixedFileUrl = '$baseUrl$fileUrlStr';
        } else {
          fixedFileUrl = fileUrlStr;
        }
      } else {
        fixedFileUrl = fileUrlStr;
      }
    }

    // ✅ Extract location data from text if exists
    double? lat;
    double? lng;
    String? locName;

    if (messageType == MessageType.location && textContent != null) {
      final text = textContent.toString();
      if (text.contains('maps.google.com/?q=')) {
        final parts = text.split('\n');
        if (parts.isNotEmpty) {
          locName = parts[0]; // First line is location name
        }
        // Try to extract coordinates from URL
        final urlPart = text.substring(text.indexOf('maps.google.com'));
        final coordMatch = RegExp(r'q=(-?\d+\.?\d*),(-?\d+\.?\d*)').firstMatch(urlPart);
        if (coordMatch != null) {
          lat = double.tryParse(coordMatch.group(1) ?? '');
          lng = double.tryParse(coordMatch.group(2) ?? '');
        }
      }
    }

    // Use provided coordinates if not extracted from text
    lat ??= json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null;
    lng ??= json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null;
    locName ??= json['location_name'];

    return ChatMessage(
      id: json['id'],
      senderId: json['sender']?['id'] ?? json['sender_id'],
      receiverId: json['receiver']?['id'] ?? json['receiver_id'],
      text: textContent,
      type: messageType,
      status: MessageStatus.delivered,
      timestamp: parsedTime,
      isSentByMe: (json['sender']?['id'] ?? json['sender_id']) == currentUserId,
      fileUrl: fixedFileUrl,
      fileName: json['file_name'],
      fileType: json['file_type'] ?? json['message_type'],
      fileSize: json['file_size'],
      latitude: lat,
      longitude: lng,
      locationName: locName,
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