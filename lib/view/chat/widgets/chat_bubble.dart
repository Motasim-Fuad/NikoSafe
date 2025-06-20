// widgets/chat_bubble.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../models/ChatModel/chat_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatModel message;

  const ChatBubble({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isSentByMe;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isMe ? Colors.teal : Colors.grey[700],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.localImageFile != null)
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(message.localImageFile!),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            if (message.message.isNotEmpty)
              Text(message.message,
                  style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
