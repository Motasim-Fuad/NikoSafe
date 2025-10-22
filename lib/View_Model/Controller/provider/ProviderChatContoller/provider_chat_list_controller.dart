// Path: View_Model/Controller/provider/ProviderChatListController/provider_chat_list_controller.dart

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/Provider/chat_repo/service_chat_repo.dart';
import 'package:nikosafe/models/Provider/chat/provider_chat_model.dart';

class ProviderChatListController extends GetxController {
  final ServiceChatRepo _chatRepo = ServiceChatRepo();

  var conversations = <ServiceChatModel>[].obs;
  var filteredConversations = <ServiceChatModel>[].obs;
  var isLoading = false.obs;
  var searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadConversations();
  }

  /// 📥 Load all conversations for provider
  Future<void> loadConversations() async {
    try {
      isLoading.value = true;

      if (kDebugMode) print('📥 Loading provider conversations...');

      final response = await _chatRepo.getAllServiceConversations();

      if (kDebugMode) print('📦 Provider conversations response: $response');

      // Handle different response structures
      List<dynamic>? conversationsJson;

      if (response['results'] != null) {
        conversationsJson = response['results'] as List?;
      } else if (response['data'] != null) {
        conversationsJson = response['data'] as List?;
      } else if (response['conversations'] != null) {
        conversationsJson = response['conversations'] as List?;
      }

      if (conversationsJson != null && conversationsJson.isNotEmpty) {
        final loadedConversations = conversationsJson
            .map((json) => ServiceChatModel.fromJson(json))
            .toList();

        conversations.value = loadedConversations;
        filteredConversations.value = loadedConversations;

        if (kDebugMode) {
          print('✅ Loaded ${conversations.length} provider conversations');
        }
      } else {
        conversations.clear();
        filteredConversations.clear();
        if (kDebugMode) print('ℹ️ No conversations found');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Error loading provider conversations: $e');
        print('Stack trace: $stackTrace');
      }
      conversations.clear();
      filteredConversations.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔄 Refresh conversations
  Future<void> refreshConversations() async {
    if (kDebugMode) print('🔄 Refreshing provider conversations...');
    await loadConversations();
  }

  /// 🔍 Update search filter
  void updateSearch(String query) {
    searchText.value = query;

    if (query.isEmpty) {
      filteredConversations.value = List.from(conversations);
    } else {
      filteredConversations.value = conversations.where((convo) {
        final name = convo.name.toLowerCase();
        final email = convo.email.toLowerCase();
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) || email.contains(searchLower);
      }).toList();
    }

    if (kDebugMode) {
      print('🔍 Search: "$query" - Found ${filteredConversations.length} results');
    }
  }
}