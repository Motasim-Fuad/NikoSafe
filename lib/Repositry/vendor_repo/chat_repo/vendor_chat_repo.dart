import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:nikosafe/Data/Network/Network_api_services.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';

class VendorChatRepo {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // Upload file for vendor chat
  Future<Map<String, dynamic>> uploadVendorChatFile({
    required File file,
    required int vendorId,
    String? text,
  }) async {
    try {
      if (kDebugMode) {
        print('📤 Uploading vendor chat file...');
        print('Vendor ID: $vendorId');
      }

      final response = await _apiServices.postMultipartApi(
        url: '${AppUrl.base_url}/api/vendorchat/upload-file/',
        data: {
          'vendor_id': vendorId,
          if (text != null && text.isNotEmpty) 'text': text,
        },
        imageFile: file,
        imageFieldName: 'file',
        requireAuth: true,
      );

      if (kDebugMode) print('✅ Vendor file upload response: $response');
      return response;
    } catch (e) {
      if (kDebugMode) print('❌ Vendor file upload error: $e');
      rethrow;
    }
  }

  // Get vendor chat history
  Future<Map<String, dynamic>> getVendorChatHistory({
    required int vendorId,
  }) async {
    try {
      final url = '${AppUrl.base_url}/api/vendorchat/messages/$vendorId/';

      if (kDebugMode) print('📥 Fetching vendor chat history: $url');

      final response = await _apiServices.getApi(url, requireAuth: true);

      if (kDebugMode) print('✅ Vendor chat history: $response');
      return response;
    } catch (e) {
      if (kDebugMode) print('❌ Error fetching vendor chat: $e');
      rethrow;
    }
  }

  // Get all vendor conversations
  Future<Map<String, dynamic>> getAllVendorConversations() async {
    try {
      final url = '${AppUrl.base_url}/api/vendorchat/conversations/';

      if (kDebugMode) print('📥 Fetching vendor conversations: $url');

      final response = await _apiServices.getApi(url, requireAuth: true);

      if (kDebugMode) print('✅ Vendor conversations: $response');
      return response;
    } catch (e) {
      if (kDebugMode) print('❌ Error fetching vendor conversations: $e');
      rethrow;
    }
  }
}