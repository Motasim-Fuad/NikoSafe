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

  Rxn<ServiceChatModel> selectedProvider = Rxn<ServiceChatModel>();
  int? currentUserId;

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
    if (kDebugMode) print('Current user ID: $currentUserId');
  }

  void _listenWebSocket() {
    _wsSubscription?.cancel();

    _wsSubscription = _wsService.messageStream.listen((data) {
      final type = data['type']?.toString();
      if (kDebugMode) print('📩 Service WS Message: $data');

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

      final selected = selectedProvider.value;
      if (selected == null) return;

      final isFromCurrentChat =
          msg.providerId == selected.id || msg.userId == currentUserId;

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
        if (selectedProvider.value != null) {
          _chatCache[selectedProvider.value!.id] = List.from(messages);
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
      if (selectedProvider.value != null) {
        _chatCache[selectedProvider.value!.id] = List.from(messages);
      }
    }
  }

  /// 🟢 Open provider chat
  Future<void> openChat(ServiceChatModel provider) async {
    selectedProvider.value = provider;
    if (kDebugMode) print('Opening chat: ${provider.name}');

    // Load from cache first
    if (_chatCache.containsKey(provider.id) && _chatCache[provider.id]!.isNotEmpty) {
      if (kDebugMode) print('📦 Loading ${_chatCache[provider.id]!.length} messages from cache');
      messages.value = List.from(_chatCache[provider.id]!);
    } else {
      messages.clear();
    }

    try {
      isConnecting.value = true;
      await _wsService.connect(provider.id);
      await _loadHistory(provider.id);
      isConnecting.value = false;
    } catch (e) {
      isConnecting.value = false;
      if (kDebugMode) print('❌ Error opening service chat: $e');
      Utils.errorSnackBar('Failed to open chat', e.toString());
    }
  }

  /// 📜 Load chat history
  Future<void> _loadHistory(int providerId) async {
    if (currentUserId == null) return;

    try {
      isLoading.value = true;

      final res = await _chatRepo.getServiceChatHistory(providerId: providerId);

      if (kDebugMode) print('🔍 Loading chat history for provider: $providerId');

      // Handle nested response structure
      List<dynamic>? messagesJson;

      if (res['results'] != null) {
        final results = res['results'];
        if (results is Map && results['messages'] != null) {
          messagesJson = results['messages'] as List?;
        }
      } else if (res['data'] != null) {
        messagesJson = res['data'] as List?;
      } else if (res['messages'] != null) {
        messagesJson = res['messages'] as List?;
      }

      if (messagesJson != null && messagesJson.isNotEmpty) {
        final list = <ServiceProviderChatMessage>[];

        for (var json in messagesJson) {
          try {
            list.add(ServiceProviderChatMessage.fromJson(
              json,
              currentUserId!,
              baseUrl: AppUrl.base_url,
            ));
          } catch (e) {
            if (kDebugMode) print('⚠️ Skip invalid message: $e');
          }
        }

        if (list.isNotEmpty) {
          messages.value = list;
          _chatCache[providerId] = List.from(list);
          if (kDebugMode) {
            print('✅ Loaded ${list.length} messages from server');
            print('💾 Cache updated with ${list.length} messages');
          }
        }
      } else {
        if (kDebugMode) print('ℹ️ No messages found for provider $providerId');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('⚠️ Could not load service chat history: $e');
        print('Stack trace: $stackTrace');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// 💬 Send text message - RENAMED FROM sendText to sendTextMessage
  Future<void> sendTextMessage(String text) async {
    if (text.trim().isEmpty || selectedProvider.value == null || currentUserId == null) return;

    final tempId = DateTime.now().millisecondsSinceEpoch;
    final msg = ServiceProviderChatMessage(
      id: tempId,
      userId: currentUserId!,
      providerId: selectedProvider.value!.id,
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
    _chatCache[selectedProvider.value!.id] = List.from(messages);

    try {
      final payload = {
        'type': 'send_message',
        'receiver_id': selectedProvider.value!.id,
        'message': text.trim(),
      };

      _wsService.sendMessage(payload);

      if (kDebugMode) print('📤 Text message sent to provider');
    } catch (e) {
      if (kDebugMode) print('❌ Error sending service message: $e');

      final idx = messages.indexWhere((m) => m.id == tempId);
      if (idx != -1) {
        messages[idx] = msg.copyWith(
          status: ServiceProviderMessageStatus.failed,
          errorMessage: 'Failed to send',
        );
        _chatCache[selectedProvider.value!.id] = List.from(messages);
      }

      Utils.errorSnackBar('Send Error', 'Message not sent');
    }
  }

  /// 📎 Send file message - RENAMED FROM sendFile to sendFileMessage
  Future<void> sendFileMessage({
    File? file,
    String? text,
  }) async {
    if (selectedProvider.value == null || currentUserId == null) return;
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

    final msg = ServiceProviderChatMessage(
      id: tempId,
      userId: currentUserId!,
      providerId: selectedProvider.value!.id,
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
    _chatCache[selectedProvider.value!.id] = List.from(messages);

    try {
      if (file != null) {
        isUploading.value = true;

        final res = await _chatRepo.uploadServiceChatFile(
          file: file,
          providerId: selectedProvider.value!.id,
          text: text,
        );

        isUploading.value = false;

        if (res['success'] == true && res['data'] != null) {
          final fileData = res['data'];

          if (kDebugMode) print('✅ Service file uploaded');

          final serverMsg = ServiceProviderChatMessage.fromJson(
            fileData,
            currentUserId!,
            baseUrl: AppUrl.base_url,
          );

          final idx = messages.indexWhere((m) => m.id == tempId);
          if (idx != -1) {
            messages[idx] = serverMsg;
            _chatCache[selectedProvider.value!.id] = List.from(messages);
          }

          _wsService.sendMessage({
            'type': 'file_uploaded',
            'receiver_id': selectedProvider.value!.id,
            'message_id': fileData['id'],
          });
        } else {
          throw Exception('Upload failed');
        }
      }
    } catch (e) {
      isUploading.value = false;
      if (kDebugMode) print('❌ Error sending service file: $e');

      final idx = messages.indexWhere((m) => m.id == tempId);
      if (idx != -1) {
        messages[idx] = msg.copyWith(
          status: ServiceProviderMessageStatus.failed,
          errorMessage: 'Upload failed',
        );
        _chatCache[selectedProvider.value!.id] = List.from(messages);
      }

      Utils.errorSnackBar('Error', 'File not sent');
    }
  }

  /// 🔁 Retry failed message - RENAMED FROM retry to retryMessage
  void retryMessage(ServiceProviderChatMessage msg) {
    if (msg.status != ServiceProviderMessageStatus.failed) return;

    messages.removeWhere((m) => m.id == msg.id);
    if (selectedProvider.value != null) {
      _chatCache[selectedProvider.value!.id] = List.from(messages);
    }

    if (msg.messageType == ServiceProviderMessageType.text) {
      sendTextMessage(msg.text ?? '');
    } else if (msg.localFile != null) {
      sendFileMessage(file: msg.localFile, text: msg.text);
    }
  }

  /// 🔒 Close chat
  void closeChat() {
    // Don't clear messages and cache, just set selectedProvider to null
    selectedProvider.value = null;
    if (kDebugMode) print('🔒 Chat closed, cache preserved');
  }

  /// 🗑️ Clear all cache (for logout)
  void clearAllCache() {
    _chatCache.clear();
    messages.clear();
    selectedProvider.value = null;
    if (kDebugMode) print('🗑️ All cache cleared');
  }

  @override
  void onClose() {
    _wsSubscription?.cancel();
    _wsService.disconnect();
    super.onClose();
  }
}