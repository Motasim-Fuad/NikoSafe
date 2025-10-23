// 🎯 UNIFIED SERVICE CHAT CONTROLLER
// Works for BOTH User → Provider AND Provider → User chat

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/Provider/chat_repo/service_chat_repo.dart';
import 'package:nikosafe/View_Model/Services/provider/service_websocket_service.dart';
import 'package:nikosafe/models/Provider/chat/provider_chat_model.dart';
import 'package:nikosafe/models/Provider/chat/provider_message_model.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';
import 'package:nikosafe/utils/token_manager.dart';
import 'package:nikosafe/utils/utils.dart';

class ServiceChatController extends GetxController {
  final ServiceChatRepo _chatRepo = ServiceChatRepo();
  final ServiceWebSocketService _wsService = ServiceWebSocketService();

  var messages = <ServiceProviderChatMessage>[].obs;
  var isLoading = false.obs;
  var isConnecting = false.obs;
  var isUploading = false.obs;

  Rxn<ServiceChatModel> selectedContact = Rxn<ServiceChatModel>(); // ✅ Generic name
  int? currentUserId;
  bool? isCurrentUserProvider; // ✅ Track if logged-in user is provider

  StreamSubscription? _wsSubscription;
  final Map<int, List<ServiceProviderChatMessage>> _chatCache = {};

  @override
  void onInit() {
    super.onInit();
    _initUser();
    _listenWebSocket();
  }

  Future<void> _initUser() async {
    currentUserId = await TokenManager.getUserId();

    // ✅ Detect if current user is a provider
    // You can add your own logic here based on your auth system
    // For example: check user role, or check if provider_id exists
    isCurrentUserProvider = await TokenManager.isProvider(); // Add this method

    if (kDebugMode) {
      print('Current user ID: $currentUserId');
      print('Is Provider: $isCurrentUserProvider');
    }
  }

  void _listenWebSocket() {
    _wsSubscription?.cancel();

    _wsSubscription = _wsService.messageStream.listen((data) {
      final type = data['type']?.toString();
      if (kDebugMode) print('📩 WS Message: $data');

      switch (type) {
        case 'connection_established':
          isConnecting.value = false;
          Utils.successSnackBar('Connected', 'Chat connected');
          break;
        case 'new_message':
        case 'message':
          _onIncomingMessage(data);
          break;
        case 'message_sent':
          _onMessageSent(data);
          break;
        case 'message_delivered':
          _updateStatus(data['message_id'], ServiceProviderMessageStatus.delivered);
          break;
        case 'message_read':
          _updateStatus(data['message_id'], ServiceProviderMessageStatus.read);
          break;
        case 'connection_lost':
          Utils.toastMessage('Disconnected, reconnecting...');
          break;
        case 'connection_failed':
          isConnecting.value = false;
          Utils.errorSnackBar('Connection Failed', 'Check your internet');
          break;
        case 'error':
          Utils.errorSnackBar('Error', data['message'] ?? 'Unknown error');
          break;
      }
    });
  }

  void _onIncomingMessage(Map<String, dynamic> data) {
    if (currentUserId == null) return;

    try {
      final msgData = data['message'] ?? data;
      final msg = ServiceProviderChatMessage.fromJson(
        msgData,
        currentUserId!,
        baseUrl: AppUrl.base_url,
      );

      final selected = selectedContact.value;
      if (selected == null) return;

      // ✅ Smart detection: Check if message belongs to current chat
      bool isFromCurrentChat = false;

      if (isCurrentUserProvider == true) {
        // Provider perspective: chatting with user (selected.id = user_id)
        isFromCurrentChat = msg.userId == selected.id;
      } else {
        // User perspective: chatting with provider (selected.id = provider_id)
        isFromCurrentChat = msg.providerId == selected.id;
      }

      if (isFromCurrentChat) {
        final exists = messages.any((m) => m.id == msg.id);
        if (!exists) {
          messages.add(msg);
          _chatCache[selected.id] = List.from(messages);
          if (kDebugMode) print('✅ Added new message: ${msg.displayText}');
        }
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error parsing WS message: $e');
    }
  }

  void _onMessageSent(Map<String, dynamic> data) {
    final messageData = data['message'];
    if (messageData == null || currentUserId == null) return;

    try {
      final msg = ServiceProviderChatMessage.fromJson(
        messageData,
        currentUserId!,
        baseUrl: AppUrl.base_url,
      );

      final idx = messages.indexWhere(
            (m) => m.text == msg.text && m.status == ServiceProviderMessageStatus.sending,
      );

      if (idx != -1) {
        messages[idx] = msg.copyWith(status: ServiceProviderMessageStatus.sent);
        if (selectedContact.value != null) {
          _chatCache[selectedContact.value!.id] = List.from(messages);
        }
        if (kDebugMode) print('✅ Message confirmed: ${msg.id}');
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error on message_sent: $e');
    }
  }

  void _updateStatus(int? id, ServiceProviderMessageStatus status) {
    if (id == null) return;
    final index = messages.indexWhere((m) => m.id == id);
    if (index != -1) {
      messages[index] = messages[index].copyWith(
        status: status,
        isRead: status == ServiceProviderMessageStatus.read,
      );
      if (selectedContact.value != null) {
        _chatCache[selectedContact.value!.id] = List.from(messages);
      }
    }
  }

  /// 🟢 Open chat (works for both user and provider)
  // In ServiceChatController, update the openChat method
  Future<void> openChat(ServiceChatModel contact) async {
    selectedContact.value = contact;

    if (kDebugMode) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('Opening chat with User ID: ${contact.id}');
      print('User Name: ${contact.name}');
      print('Current Provider ID: $currentUserId');
      print('Is Provider: $isCurrentUserProvider');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }

    // Load from cache
    if (_chatCache.containsKey(contact.id) && _chatCache[contact.id]!.isNotEmpty) {
      if (kDebugMode) print('📦 Loading ${_chatCache[contact.id]!.length} messages from cache');
      messages.value = List.from(_chatCache[contact.id]!);
    } else {
      messages.clear();
    }

    try {
      isConnecting.value = true;

      // ✅ Connect with USER ID (the contact.id is the user ID)
      await _wsService.connect(contact.id);
      await _loadHistory(contact.id); // This now passes user ID

      isConnecting.value = false;
    } catch (e) {
      isConnecting.value = false;
      if (kDebugMode) print('❌ Error opening chat with user ${contact.id}: $e');
      Utils.errorSnackBar('Failed to open chat', e.toString());
    }
  }

  /// 📜 Load chat history
  // In ServiceChatController, update the _loadHistory method
  /// 📜 Load chat history
  Future<void> _loadHistory(int userId) async {
    if (currentUserId == null) return;

    try {
      isLoading.value = true;

      // ✅ API call with USER ID
      final res = await _chatRepo.getServiceChatHistory(userId: userId);


      _debugResponseStructure(res);

      if (kDebugMode) {
        print('🔍 Loading chat history with user: $userId');
        print('📦 Full API response: $res');
      }

      List<dynamic>? messagesJson;

      // ✅ FIXED: Properly extract messages from the nested structure
      if (res['results'] != null && res['results'] is Map) {
        final results = res['results'] as Map;
        if (results['success'] == true && results['messages'] != null) {
          messagesJson = results['messages'] as List?;
          if (kDebugMode) print('✅ Found messages in results.messages: ${messagesJson?.length}');
        }
      }

      // ✅ Alternative: Check if messages are directly in response
      else if (res['messages'] != null) {
        messagesJson = res['messages'] as List?;
        if (kDebugMode) print('✅ Found messages directly in response: ${messagesJson?.length}');
      }

      // ✅ Another alternative: Check in data field
      else if (res['data'] != null) {
        messagesJson = res['data'] as List?;
        if (kDebugMode) print('✅ Found messages in data: ${messagesJson?.length}');
      }

      if (messagesJson != null && messagesJson.isNotEmpty) {
        final list = <ServiceProviderChatMessage>[];

        for (var json in messagesJson) {
          try {
            final message = ServiceProviderChatMessage.fromJson(
              json,
              currentUserId!,
              baseUrl: AppUrl.base_url,
            );
            list.add(message);
            if (kDebugMode) print('📨 Parsed message: ${message.id} - ${message.text}');
          } catch (e) {
            if (kDebugMode) print('⚠️ Skip invalid message: $e | JSON: $json');
          }
        }

        if (list.isNotEmpty) {
          // ✅ Sort messages by creation time (oldest first)
          list.sort((a, b) => a.createdAt.compareTo(b.createdAt));

          messages.value = list;
          _chatCache[userId] = List.from(list);
          if (kDebugMode) print('✅ Successfully loaded ${list.length} messages with user $userId');
        } else {
          if (kDebugMode) print('⚠️ No valid messages could be parsed');
        }
      } else {
        if (kDebugMode) print('ℹ️ No messages found with user $userId');
        messages.clear();
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Could not load chat history with user $userId: $e');
        print('Stack trace: $stackTrace');
      }
      messages.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// 🐛 Temporary debug method to check the response structure
  void _debugResponseStructure(Map<String, dynamic> res) {
    if (kDebugMode) {
      print('🔍 DEBUG - Response structure analysis:');
      print('Keys in response: ${res.keys.toList()}');

      if (res['results'] != null) {
        print('Results type: ${res['results'].runtimeType}');
        if (res['results'] is Map) {
          final results = res['results'] as Map;
          print('Keys in results: ${results.keys.toList()}');
          if (results['messages'] != null) {
            print('Messages type: ${results['messages'].runtimeType}');
            if (results['messages'] is List) {
              print('Number of messages: ${(results['messages'] as List).length}');
            }
          }
        }
      }

      if (res['messages'] != null) {
        print('Direct messages type: ${res['messages'].runtimeType}');
        if (res['messages'] is List) {
          print('Number of direct messages: ${(res['messages'] as List).length}');
        }
      }
    }
  }

  /// 💬 Send text message
  Future<void> sendTextMessage(String text) async {
    if (text.trim().isEmpty || selectedContact.value == null || currentUserId == null) return;

    final tempId = DateTime.now().millisecondsSinceEpoch;

    // ✅ Create message with proper user_id and provider_id
    int userId;
    int providerId;

    if (isCurrentUserProvider == true) {
      // Provider sending to user
      userId = selectedContact.value!.id;
      providerId = currentUserId!;
    } else {
      // User sending to provider
      userId = currentUserId!;
      providerId = selectedContact.value!.id;
    }

    final msg = ServiceProviderChatMessage(
      id: tempId,
      userId: userId,
      providerId: providerId,
      senderId: currentUserId!,
      senderEmail: '',
      senderName: 'You',
      text: text.trim(),
      messageType: ServiceProviderMessageType.text,
      isRead: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSentByMe: true,
      status: ServiceProviderMessageStatus.sending,
    );

    messages.add(msg);
    _chatCache[selectedContact.value!.id] = List.from(messages);

    try {
      final payload = {
        'type': 'send_message',
        'receiver_id': selectedContact.value!.id,
        'message': text.trim(),
      };

      _wsService.sendMessage(payload);

      if (kDebugMode) print('📤 Text message sent to ${selectedContact.value!.name}');
    } catch (e) {
      if (kDebugMode) print('❌ Error sending message: $e');

      final idx = messages.indexWhere((m) => m.id == tempId);
      if (idx != -1) {
        messages[idx] = msg.copyWith(
          status: ServiceProviderMessageStatus.failed,
          errorMessage: 'Failed to send',
        );
        _chatCache[selectedContact.value!.id] = List.from(messages);
      }

      Utils.errorSnackBar('Send Error', 'Message not sent');
    }
  }

  /// 📎 Send file message
  Future<void> sendFileMessage({
    File? file,
    String? text,
  }) async {
    if (selectedContact.value == null || currentUserId == null) return;
    if (file == null && (text == null || text.trim().isEmpty)) return;

    final tempId = DateTime.now().millisecondsSinceEpoch;

    ServiceProviderMessageType messageType = ServiceProviderMessageType.text;
    if (file != null) {
      final extension = file.path.split('.').last.toLowerCase();
      if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
        messageType = ServiceProviderMessageType.image;
      } else if (['mp4', 'mov', 'avi', 'mkv'].contains(extension)) {
        messageType = ServiceProviderMessageType.video;
      } else {
        messageType = ServiceProviderMessageType.file;
      }
    }

    int userId;
    int providerId;

    if (isCurrentUserProvider == true) {
      userId = selectedContact.value!.id;
      providerId = currentUserId!;
    } else {
      userId = currentUserId!;
      providerId = selectedContact.value!.id;
    }

    final msg = ServiceProviderChatMessage(
      id: tempId,
      userId: userId,
      providerId: providerId,
      senderId: currentUserId!,
      senderEmail: '',
      senderName: 'You',
      text: text?.trim(),
      messageType: messageType,
      isRead: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSentByMe: true,
      status: ServiceProviderMessageStatus.sending,
      localFile: file,
    );

    messages.add(msg);
    _chatCache[selectedContact.value!.id] = List.from(messages);

    try {
      if (file != null) {
        isUploading.value = true;

        final res = await _chatRepo.uploadServiceChatFile(
          file: file,
          providerId: selectedContact.value!.id,
          text: text,
        );

        isUploading.value = false;

        if (res['success'] == true && res['data'] != null) {
          final fileData = res['data'];
          final serverMsg = ServiceProviderChatMessage.fromJson(
            fileData,
            currentUserId!,
            baseUrl: AppUrl.base_url,
          );

          final idx = messages.indexWhere((m) => m.id == tempId);
          if (idx != -1) {
            messages[idx] = serverMsg;
            _chatCache[selectedContact.value!.id] = List.from(messages);
          }

          _wsService.sendMessage({
            'type': 'file_uploaded',
            'receiver_id': selectedContact.value!.id,
            'message_id': fileData['id'],
          });
        } else {
          throw Exception('Upload failed');
        }
      }
    } catch (e) {
      isUploading.value = false;
      if (kDebugMode) print('❌ Error sending file: $e');

      final idx = messages.indexWhere((m) => m.id == tempId);
      if (idx != -1) {
        messages[idx] = msg.copyWith(
          status: ServiceProviderMessageStatus.failed,
          errorMessage: 'Upload failed',
        );
        _chatCache[selectedContact.value!.id] = List.from(messages);
      }

      Utils.errorSnackBar('Error', 'File not sent');
    }
  }

  /// 🔁 Retry failed message
  void retryMessage(ServiceProviderChatMessage msg) {
    if (msg.status != ServiceProviderMessageStatus.failed) return;

    messages.removeWhere((m) => m.id == msg.id);
    if (selectedContact.value != null) {
      _chatCache[selectedContact.value!.id] = List.from(messages);
    }

    if (msg.messageType == ServiceProviderMessageType.text) {
      sendTextMessage(msg.text ?? '');
    } else if (msg.localFile != null) {
      sendFileMessage(file: msg.localFile, text: msg.text);
    }
  }

  /// 🔒 Close chat
  void closeChat() {
    selectedContact.value = null;
    if (kDebugMode) print('🔒 Chat closed, cache preserved');
  }

  /// 🗑️ Clear all cache
  void clearAllCache() {
    _chatCache.clear();
    messages.clear();
    selectedContact.value = null;
    if (kDebugMode) print('🗑️ All cache cleared');
  }

  @override
  void onClose() {
    _wsSubscription?.cancel();
    _wsService.disconnect();
    super.onClose();
  }
}