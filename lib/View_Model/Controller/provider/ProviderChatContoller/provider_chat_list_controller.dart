// View_Model/Controller/provider/ProviderChatListController/provider_chat_list_controller.dart
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

  /// 📥 Load all conversations for provider and group by USER
  Future<void> loadConversations() async {
    try {
      isLoading.value = true;
      if (kDebugMode) print('📥 Loading provider conversations...');

      final response = await _chatRepo.getAllServiceConversations();
      if (kDebugMode) print('📦 Provider conversations response: $response');

      List<dynamic>? conversationsJson;

      // Extract conversations list from different possible response structures
      if (response['results'] != null) {
        conversationsJson = response['results'] as List?;
      } else if (response['data'] != null) {
        conversationsJson = response['data'] as List?;
      } else if (response['conversations'] != null) {
        conversationsJson = response['conversations'] as List?;
      }

      if (conversationsJson != null && conversationsJson.isNotEmpty) {
        // ✅ Group conversations by USER ID
        final Map<int, ServiceChatModel> usersMap = {};

        for (var json in conversationsJson) {
          try {
            final userId = _extractUserIdFromJson(json);

            if (userId == 0) {
              if (kDebugMode) print('⚠️ Skipping conversation with invalid user ID: $json');
              continue;
            }

            final conversation = ServiceChatModel.fromJson(json);

            // If this is the first time seeing this user, add them
            if (!usersMap.containsKey(userId)) {
              usersMap[userId] = conversation.copyWith(id: userId);
              if (kDebugMode) print('➕ Added new user: ID $userId, Name: ${conversation.name}');
            } else {
              // If we already have this user, keep the conversation with the latest message
              final existingUser = usersMap[userId]!;
              final existingTime = existingUser.lastMessageTime ?? DateTime(0);
              final newTime = conversation.lastMessageTime ?? DateTime(0);

              if (newTime.isAfter(existingTime)) {
                usersMap[userId] = conversation.copyWith(id: userId);
                if (kDebugMode) print('🔄 Updated user $userId with newer message');
              }
            }
          } catch (e) {
            if (kDebugMode) print('⚠️ Error processing conversation: $e\nJSON: $json');
          }
        }

        // ✅ Convert map to list
        final usersList = usersMap.values.toList();

        // ✅ Sort by last message time (newest first)
        usersList.sort((a, b) {
          if (a.lastMessageTime == null) return 1;
          if (b.lastMessageTime == null) return -1;
          return b.lastMessageTime!.compareTo(a.lastMessageTime!);
        });

        conversations.value = usersList;
        filteredConversations.value = usersList;

        if (kDebugMode) {
          print('✅ Loaded ${conversations.length} unique users');
          for (var user in conversations) {
            print('  👤 User ID: ${user.id} | Name: ${user.name} | Last Message: ${user.lastMessage}');
          }
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

  /// 🔧 Extract user ID directly from JSON
  int _extractUserIdFromJson(Map<String, dynamic> json) {
    try {
      // Try different possible field names for user ID
      if (json['user'] != null) {
        return int.tryParse(json['user'].toString()) ?? 0;
      }
      if (json['user_id'] != null) {
        return int.tryParse(json['user_id'].toString()) ?? 0;
      }
      if (json['id'] != null && json['provider'] != null) {
        // If this looks like a conversation object with user field
        return int.tryParse(json['id'].toString()) ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
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
      filteredConversations.value = conversations.where((user) {
        final name = user.name.toLowerCase();
        final email = user.email.toLowerCase();
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) || email.contains(searchLower);
      }).toList();
    }

    if (kDebugMode) {
      print('🔍 Search: "$query" - Found ${filteredConversations.length} users');
    }
  }
}