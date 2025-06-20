// models/ChatModel/chat_model.dart
import 'dart:io';

class ChatModel {
  final String message;
  final String name;
  final String title;
  final String time;
  final String imageUrl;
  final bool isSentByMe;
  final bool isOnline;
  final File? localImageFile;

  ChatModel({
    required this.message,
    required this.name,
    required this.title,
    required this.time,
    required this.imageUrl,
    required this.isSentByMe,
    required this.isOnline,
    this.localImageFile,
  });
}
