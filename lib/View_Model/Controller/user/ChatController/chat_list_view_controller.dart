// Path: View_Model/Controller/user/ChatController/chat_list_view_controller.dart

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/ChatRepo/Chat_Repositry.dart';
import 'package:nikosafe/models/User/userHome/connect_user_model.dart';
import 'package:nikosafe/utils/token_manager.dart';
import 'package:nikosafe/utils/utils.dart';

class ChatListController extends GetxController {
  final ChatRepo _chatRepo = ChatRepo();

  RxList<ConnectUser> conversations = <ConnectUser>[].obs;
  RxList<ConnectUser> filteredConversations = <ConnectUser>[].obs;
  RxString searchText = ''.obs;
  RxBool isLoading = false.obs;

  int? currentUserId;

  @override
  void onInit() {
    super.onInit();
    _getCurrentUserId();
    loadConversations();
  }

  void _getCurrentUserId() async {
    currentUserId = await TokenManager.getUserId();
    if (kDebugMode) print('Current user ID: $currentUserId');
  }

  // ✅ Load conversations from backend
  Future<void> loadConversations() async {
    try {
      isLoading.value = true;

      final response = await _chatRepo.getAllConversations();

      if (response['success'] == true && response['data'] != null) {
        List<dynamic> conversationsJson = response['data'] as List;

        if (kDebugMode) print('Total conversations: ${conversationsJson.length}');

        List<ConnectUser> convos = [];

        for (var convo in conversationsJson) {
          final user = convo['user'];
          final latestMessage = convo['latest_message'];
          final unreadCount = convo['unread_count'] ?? 0;

          if (user == null) continue;

          // ✅ Extract user info properly
          String firstName = user['first_name']?.toString().trim() ?? '';
          String lastName = user['last_name']?.toString().trim() ?? '';
          String username = user['username']?.toString().trim() ?? '';
          String email = user['email']?.toString() ?? '';

          String name = '';
          if (firstName.isNotEmpty || lastName.isNotEmpty) {
            name = '$firstName $lastName'.trim();
          } else if (username.isNotEmpty) {
            name = username;
          } else if (email.isNotEmpty) {
            name = email.split('@')[0];
          } else {
            name = 'Unknown User';
          }

          // ✅ Extract last message
          String? lastMessage;
          String? lastMessageTime;
          bool lastMessageByMe = false;

          if (latestMessage != null) {
            lastMessage = latestMessage['text'] ?? '📎 Attachment';
            lastMessageTime = latestMessage['created_at'];

            // Check if current user sent it
            if (currentUserId != null && latestMessage['sender'] != null) {
              lastMessageByMe = latestMessage['sender']['id'] == currentUserId;
            }
          }

          // ✅ Build ConnectUser object
          Map<String, dynamic> userData = {
            'id': user['id'],
            'email': email,
            'name': name,
            'profile_picture': user['profile_picture'],
            'friendship_status': 'accepted',
            'total_friends': 0,
            'total_posts': 0,
            'post_ids': [],
            'points': 0,
            'connect_percentage': 0,
            'last_message': lastMessage ?? 'Start a conversation',
            'last_message_time': lastMessageTime,
            'last_message_by_me': lastMessageByMe,
            'unread_count': unreadCount,
          };

          convos.add(ConnectUser.fromJson(userData));
        }

        conversations.value = convos;
        filteredConversations.value = convos;

        if (kDebugMode) print('✅ Conversations loaded: ${conversations.length}');
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error loading conversations: $e');
      Utils.errorSnackBar('Error', 'Failed to load conversations');
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Update search and filter
  void updateSearch(String text) {
    searchText.value = text.trim().toLowerCase();

    if (searchText.value.isEmpty) {
      filteredConversations.value = conversations;
    } else {
      filteredConversations.value = conversations.where((convo) {
        final name = convo.name.toLowerCase();
        final email = convo.email.toLowerCase();
        final query = searchText.value;

        return name.contains(query) || email.contains(query);
      }).toList();
    }

    if (kDebugMode) {
      print('Search: "${searchText.value}" - Results: ${filteredConversations.length}');
    }
  }

  // ✅ Refresh conversations
  Future<void> refreshConversations() async {
    searchText.value = '';
    await loadConversations();
  }

  @override
  void onClose() {
    super.onClose();
  }
}