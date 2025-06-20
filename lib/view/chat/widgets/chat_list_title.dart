import 'package:flutter/material.dart';

import '../../../models/ChatModel/chat_model.dart';


class ChatListTile extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;

  const ChatListTile({required this.chat, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: AssetImage(chat.imageUrl),
      ),
      title: Text(chat.name, style: const TextStyle(color: Colors.white)),
      subtitle: Text(chat.message, style: const TextStyle(color: Colors.grey)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(chat.time, style: const TextStyle(color: Colors.grey)),
          if (chat.isOnline)
            const Icon(Icons.circle, color: Colors.green, size: 10),
        ],
      ),
    );
  }
}