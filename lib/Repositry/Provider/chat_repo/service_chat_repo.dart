import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:nikosafe/Data/Network/Network_api_services.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

class ServiceChatRepo {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // Upload file for service chat
  Future<Map<String, dynamic>> uploadServiceChatFile({
    required File file,
    required int providerId,
    String? text,
  }) async {
    try {
      if (kDebugMode) {
        print('📤 Uploading service chat file...');
        print('Provider ID: $providerId');
      }

      final response = await _apiServices.postMultipartApi(
        url: '${AppUrl.base_url}/api/providerchat/upload-file/',
        data: {
          'provider_id': providerId,
          if (text != null && text.isNotEmpty) 'text': text,
        },
        imageFile: file,
        imageFieldName: 'file',
        requireAuth: true,
      );

      if (kDebugMode) print('✅ Service file upload response: $response');
      return response;
    } catch (e) {
      if (kDebugMode) print('❌ Service file upload error: $e');
      rethrow;
    }
  }

  // Get service chat history
// In ServiceChatRepo, update the getServiceChatHistory method
  Future<Map<String, dynamic>> getServiceChatHistory({
    required int userId, // ✅ Change parameter name to userId
  }) async {
    try {
      // ✅ Correct endpoint: Get messages between current provider and specific user
      final url = '${AppUrl.base_url}/api/providerchat/provider/messages/$userId/';

      if (kDebugMode) print('📥 Fetching chat history with user: $url');

      final response = await _apiServices.getApi(url, requireAuth: true);

      if (kDebugMode) print('✅ Chat history with user $userId: $response');
      return response;
    } catch (e) {
      if (kDebugMode) print('❌ Error fetching chat with user $userId: $e');
      rethrow;
    }
  }

  // Get all service conversations
  Future<Map<String, dynamic>> getAllServiceConversations() async {
    try {
      final url = '${AppUrl.base_url}/api/providerchat/conversations/';

      if (kDebugMode) print('📥 Fetching service conversations: $url');

      final response = await _apiServices.getApi(url, requireAuth: true);

      if (kDebugMode) print('✅ Service conversations: $response');
      return response;
    } catch (e) {
      if (kDebugMode) print('❌ Error fetching service conversations: $e');
      rethrow;
    }
  }
}