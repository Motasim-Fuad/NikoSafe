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
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? Colors.green : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.message,
          style: TextStyle(
            color: isMe ? Colors.black : Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
