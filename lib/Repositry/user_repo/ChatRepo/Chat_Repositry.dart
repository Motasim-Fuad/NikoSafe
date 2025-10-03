// Path: Repositry/user_repo/ChatRepo/Chat_Repositry.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:nikosafe/Data/Network/Network_api_services.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

class ChatRepo {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // Upload file (image/video) before sending via WebSocket
  Future<Map<String, dynamic>> uploadChatFile({
    required File file,
    required int receiverId,
    String? text,
  }) async {
    try {
      if (kDebugMode) {
        print('📤 Uploading chat file...');
        print('Receiver ID: $receiverId');
        print('File: ${file.path}');
      }

      final response = await _apiServices.postMultipartApi(
        url: '${AppUrl.base_url}/api/social/upload-chat-file/',
        data: {
          'receiver_id': receiverId,
          if (text != null && text.isNotEmpty) 'text': text,
        },
        imageFile: file,
        imageFieldName: 'file',
        requireAuth: true,
      );

      if (kDebugMode) print('✅ File upload response: $response');
      return response;
    } catch (e) {
      if (kDebugMode) print('❌ File upload error: $e');
      rethrow;
    }
  }

  // ✅ Get conversation history with a specific friend
  Future<Map<String, dynamic>> getChatHistory({
    required int friendId,
  }) async {
    try {
      final url = '${AppUrl.base_url}/api/social/conversations/$friendId/';

      if (kDebugMode) print('📥 Fetching chat history from: $url');

      final response = await _apiServices.getApi(url, requireAuth: true);

      if (kDebugMode) print('✅ Chat history: $response');
      return response;
    } catch (e) {
      if (kDebugMode) print('❌ Error fetching chat history: $e');
      rethrow;
    }
  }

  // ✅ Get all conversations (for chat list)
  Future<Map<String, dynamic>> getAllConversations() async {
    try {
      final url = '${AppUrl.base_url}/api/social/conversations/';

      if (kDebugMode) print('📥 Fetching all conversations from: $url');

      final response = await _apiServices.getApi(url, requireAuth: true);

      if (kDebugMode) print('✅ Conversations: $response');
      return response;
    } catch (e) {
      if (kDebugMode) print('❌ Error fetching conversations: $e');
      rethrow;
    }
  }
}