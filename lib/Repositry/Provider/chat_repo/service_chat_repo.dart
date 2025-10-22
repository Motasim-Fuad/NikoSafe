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
  Future<Map<String, dynamic>> getServiceChatHistory({
    required int providerId,
  }) async {
    try {
      final url = '${AppUrl.base_url}/api/providerchat/messages/$providerId/';

      if (kDebugMode) print('📥 Fetching service chat history: $url');

      final response = await _apiServices.getApi(url, requireAuth: true);

      if (kDebugMode) print('✅ Service chat history: $response');
      return response;
    } catch (e) {
      if (kDebugMode) print('❌ Error fetching service chat: $e');
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