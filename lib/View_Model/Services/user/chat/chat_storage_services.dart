// View_Model/Services/user/chat/chat_storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatStorageService {
  static const String _lastMessagesKey = 'last_chat_messages';

  // Save last message for a friend
  static Future<void> saveLastMessage({
    required int friendId,
    required String message,
    required String timestamp,
    required bool isSentByMe,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> allMessages = {};
    final stored = prefs.getString(_lastMessagesKey);

    if (stored != null) {
      allMessages = Map<String, dynamic>.from(jsonDecode(stored));
    }

    allMessages[friendId.toString()] = {
      'message': message,
      'timestamp': timestamp,
      'isSentByMe': isSentByMe,
    };

    await prefs.setString(_lastMessagesKey, jsonEncode(allMessages));
  }

  // Get last message for a friend
  static Future<Map<String, dynamic>?> getLastMessage(int friendId) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_lastMessagesKey);

    if (stored == null) return null;

    final allMessages = Map<String, dynamic>.from(jsonDecode(stored));
    return allMessages[friendId.toString()];
  }

  // Get all last messages
  static Future<Map<String, dynamic>> getAllLastMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_lastMessagesKey);

    if (stored == null) return {};
    return Map<String, dynamic>.from(jsonDecode(stored));
  }
}