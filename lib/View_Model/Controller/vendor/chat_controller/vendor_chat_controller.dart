// Path: View_Model/Controller/vendor/vendor_chat_controller.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/vendor_repo/chat_repo/vendor_chat_repo.dart';
import 'package:nikosafe/View_Model/Services/vendor/vendor_websocket_service.dart';
import 'package:nikosafe/models/vendor/chat/vendor_chat_model.dart';
import 'package:nikosafe/models/vendor/chat/vendor_message_model.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';
import 'package:nikosafe/utils/token_manager.dart';
import 'package:nikosafe/utils/utils.dart';

class VendorChatController extends GetxController {
  final VendorChatRepo _chatRepo = VendorChatRepo();
  final VendorWebSocketService _wsService = VendorWebSocketService();

  var messages = <VendorChatMessage>[].obs;
  var isLoading = false.obs;
  var isConnecting = false.obs;
  var isUploading = false.obs;
  Rxn<VendorChatModel> selectedVendor = Rxn<VendorChatModel>();
  int? currentUserId;

  StreamSubscription? _wsSubscription;

  // Cache to store chat histories for each vendor
  final Map<int, List<VendorChatMessage>> _chatCache = {};

  @override
  void onInit() {
    super.onInit();
    _getCurrentUserId();
    _listenToWebSocket();
  }

  void _getCurrentUserId() async {
    currentUserId = await TokenManager.getUserId();
    if (kDebugMode) print('Current user ID: $currentUserId');
  }

  void _listenToWebSocket() {
    _wsSubscription?.cancel();

    _wsSubscription = _wsService.messageStream.listen((data) {
      if (kDebugMode) print('📩 Vendor Controller received: $data');

      final messageType = data['type']?.toString();

      switch (messageType) {
        case 'connection_established':
          Utils.successSnackBar('Connected', 'Vendor chat connected');
          isConnecting.value = false;
          break;

        case 'message':
        case 'new_message':
          _handleIncomingMessage(data);
          break;

        case 'message_sent':
          _handleMessageSent(data);
          break;

        case 'message_delivered':
          _updateMessageStatus(data['message_id'], VendorMessageStatus.delivered);
          break;

        case 'message_read':
          _updateMessageStatus(data['message_id'], VendorMessageStatus.read);
          break;

        case 'error':
          Utils.errorSnackBar('Error', data['message'] ?? 'Unknown error');
          break;

        case 'connection_lost':
          Utils.toastMessage('Disconnected \nReconnecting...');
          break;

        case 'connection_failed':
          Utils.errorSnackBar('Connection Failed', 'Please check internet');
          isConnecting.value = false;
          break;
      }
    });
  }

  void _handleIncomingMessage(Map<String, dynamic> data) {
    if (currentUserId == null) return;

    try {
      final messageData = data['message'] ?? data;

      final message = VendorChatMessage.fromVendorJson(
        messageData,
        currentUserId!,
        baseUrl: AppUrl.base_url,
      );

      // Check if message belongs to current vendor chat
      final isFromCurrentChat = message.vendorId == selectedVendor.value?.id;

      if (isFromCurrentChat) {
        // Avoid duplicates
        final exists = messages.any((m) => m.id == message.id);
        if (!exists) {
          messages.add(message);

          // Update cache
          if (selectedVendor.value != null) {
            _chatCache[selectedVendor.value!.id] = List.from(messages);
          }

          if (kDebugMode) {
            print('✅ Vendor message added: ${message.displayText}');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error handling vendor message: $e');
    }
  }

  void _handleMessageSent(Map<String, dynamic> data) {
    final messageData = data['message'];
    if (messageData == null) return;

    try {
      final serverMessage = VendorChatMessage.fromVendorJson(
        messageData,
        currentUserId!,
        baseUrl: AppUrl.base_url,
      );

      // Find and update the sending message
      final index = messages.indexWhere((m) =>
      m.text == serverMessage.text &&
          m.status == VendorMessageStatus.sending
      );

      if (index != -1) {
        messages[index] = serverMessage.copyWith(status: VendorMessageStatus.sent);

        // Update cache
        if (selectedVendor.value != null) {
          _chatCache[selectedVendor.value!.id] = List.from(messages);
        }

        if (kDebugMode) print('✅ Message sent confirmed: ID ${serverMessage.id}');
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error handling message_sent: $e');
    }
  }

  void _updateMessageStatus(int? messageId, VendorMessageStatus status) {
    if (messageId == null) return;

    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(
        status: status,
        isRead: status == VendorMessageStatus.read,
      );

      // Update cache
      if (selectedVendor.value != null) {
        _chatCache[selectedVendor.value!.id] = List.from(messages);
      }
    }
  }

  Future<void> openChat(VendorChatModel vendor) async {
    selectedVendor.value = vendor;

    if (kDebugMode) print('Opening vendor chat: ${vendor.name} (ID: ${vendor.id})');

    // Check cache first for instant loading
    if (_chatCache.containsKey(vendor.id) && _chatCache[vendor.id]!.isNotEmpty) {
      if (kDebugMode) print('📦 Loading ${_chatCache[vendor.id]!.length} messages from cache');
      messages.value = List.from(_chatCache[vendor.id]!);
    } else {
      messages.clear();
    }

    try {
      isConnecting.value = true;

      // Connect to WebSocket
      await _wsService.connect(vendor.id);

      // Load chat history from server
      await _loadChatHistory(vendor.id);

      isConnecting.value = false;
    } catch (e) {
      isConnecting.value = false;
      if (kDebugMode) print('❌ Error opening vendor chat: $e');
      Utils.errorSnackBar('Error', 'Failed to connect to vendor chat');
    }
  }

  Future<void> _loadChatHistory(int vendorId) async {
    try {
      isLoading.value = true;

      final response = await _chatRepo.getVendorChatHistory(vendorId: vendorId);

      if (kDebugMode) {
        print('🔍 Loading chat history for vendor: $vendorId');
      }

      // Handle nested response structure
      List<dynamic>? messagesJson;

      if (response['results'] != null) {
        final results = response['results'];
        if (results is Map && results['messages'] != null) {
          messagesJson = results['messages'] as List?;
        }
      } else if (response['data'] != null) {
        messagesJson = response['data'] as List?;
      } else if (response['messages'] != null) {
        messagesJson = response['messages'] as List?;
      }

      if (messagesJson != null && messagesJson.isNotEmpty) {
        // Parse all messages safely
        final loadedMessages = <VendorChatMessage>[];

        for (var json in messagesJson) {
          try {
            final message = VendorChatMessage.fromVendorJson(
              json,
              currentUserId!,
              baseUrl: AppUrl.base_url,
            );
            loadedMessages.add(message);
          } catch (e) {
            if (kDebugMode) {
              print('⚠️ Skipping message due to parse error: $e');
            }
          }
        }

        if (loadedMessages.isNotEmpty) {
          messages.value = loadedMessages;

          // Update cache
          _chatCache[vendorId] = List.from(loadedMessages);

          if (kDebugMode) {
            print('✅ Loaded ${messages.length} vendor messages from server');
            print('💾 Cache updated with ${loadedMessages.length} messages');
          }
        }
      } else {
        if (kDebugMode) print('ℹ️ No messages found for vendor $vendorId');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('⚠️ Could not load vendor chat history: $e');
        print('Stack trace: $stackTrace');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendTextMessage(String text) async {
    if (text.trim().isEmpty || selectedVendor.value == null) return;

    final tempId = DateTime.now().millisecondsSinceEpoch;

    final message = VendorChatMessage(
      id: tempId,
      userId: currentUserId!,
      vendorId: selectedVendor.value!.id,
      senderId: currentUserId!,
      senderEmail: '',
      senderName: '',
      text: text.trim(),
      messageType: VendorMessageType.text,
      status: VendorMessageStatus.sending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSentByMe: true,
      isRead: false,
    );

    messages.add(message);

    // Update cache immediately
    if (selectedVendor.value != null) {
      _chatCache[selectedVendor.value!.id] = List.from(messages);
    }

    try {
      final payload = {
        'type': 'send_message',
        'receiver_id': selectedVendor.value!.id,
        'message': text.trim(),
      };

      _wsService.sendMessage(payload);

      if (kDebugMode) print('📤 Text message sent');
    } catch (e) {
      if (kDebugMode) print('❌ Error sending vendor message: $e');

      final index = messages.indexWhere((m) => m.id == tempId);
      if (index != -1) {
        messages[index] = message.copyWith(
          status: VendorMessageStatus.failed,
          errorMessage: 'Failed to send',
        );

        // Update cache
        if (selectedVendor.value != null) {
          _chatCache[selectedVendor.value!.id] = List.from(messages);
        }
      }

      Utils.errorSnackBar('Error', 'Message not sent');
    }
  }

  Future<void> sendFileMessage({
    File? file,
    String? text,
  }) async {
    if (selectedVendor.value == null) return;
    if (file == null && (text == null || text.trim().isEmpty)) return;

    final tempId = DateTime.now().millisecondsSinceEpoch;

    VendorMessageType messageType = VendorMessageType.text;
    if (file != null) {
      final extension = file.path.split('.').last.toLowerCase();
      if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
        messageType = VendorMessageType.image;
      } else if (['mp4', 'mov', 'avi', 'mkv'].contains(extension)) {
        messageType = VendorMessageType.video;
      } else {
        messageType = VendorMessageType.file;
      }
    }

    final message = VendorChatMessage(
      id: tempId,
      userId: currentUserId!,
      vendorId: selectedVendor.value!.id,
      senderId: currentUserId!,
      senderEmail: '',
      senderName: '',
      text: text?.trim(),
      messageType: messageType,
      status: VendorMessageStatus.sending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSentByMe: true,
      isRead: false,
      localFile: file,
    );

    messages.add(message);

    // Update cache
    if (selectedVendor.value != null) {
      _chatCache[selectedVendor.value!.id] = List.from(messages);
    }

    try {
      if (file != null) {
        isUploading.value = true;

        final uploadResponse = await _chatRepo.uploadVendorChatFile(
          file: file,
          vendorId: selectedVendor.value!.id,
          text: text,
        );

        isUploading.value = false;

        if (uploadResponse['success'] == true && uploadResponse['data'] != null) {
          final fileData = uploadResponse['data'];

          if (kDebugMode) print('✅ Vendor file uploaded');

          final serverMessage = VendorChatMessage.fromVendorJson(
            fileData,
            currentUserId!,
            baseUrl: AppUrl.base_url,
          );

          final index = messages.indexWhere((m) => m.id == tempId);
          if (index != -1) {
            messages[index] = serverMessage;

            // Update cache
            if (selectedVendor.value != null) {
              _chatCache[selectedVendor.value!.id] = List.from(messages);
            }
          }

          _wsService.sendMessage({
            'type': 'file_uploaded',
            'receiver_id': selectedVendor.value!.id,
            'message_id': fileData['id'],
          });
        } else {
          throw Exception('File upload failed');
        }
      }
    } catch (e) {
      isUploading.value = false;
      if (kDebugMode) print('❌ Error sending vendor file: $e');

      final index = messages.indexWhere((m) => m.id == tempId);
      if (index != -1) {
        messages[index] = message.copyWith(
          status: VendorMessageStatus.failed,
          errorMessage: 'Failed to send',
        );

        // Update cache
        if (selectedVendor.value != null) {
          _chatCache[selectedVendor.value!.id] = List.from(messages);
        }
      }

      Utils.errorSnackBar('Error', 'Failed to send file');
    }
  }

  void retryMessage(VendorChatMessage message) {
    if (message.status != VendorMessageStatus.failed) return;

    messages.removeWhere((m) => m.id == message.id);

    // Update cache
    if (selectedVendor.value != null) {
      _chatCache[selectedVendor.value!.id] = List.from(messages);
    }

    if (message.messageType == VendorMessageType.text) {
      sendTextMessage(message.text ?? '');
    } else if (message.localFile != null) {
      sendFileMessage(file: message.localFile, text: message.text);
    }
  }

  void closeChat() {
    // Don't clear messages and cache, just set selectedVendor to null
    selectedVendor.value = null;
    if (kDebugMode) print('🔒 Chat closed, cache preserved');
  }

  // Method to clear all cached data (for logout)
  void clearAllCache() {
    _chatCache.clear();
    messages.clear();
    selectedVendor.value = null;
    if (kDebugMode) print('🗑️ All cache cleared');
  }

  @override
  void onClose() {
    _wsSubscription?.cancel();
    _wsService.disconnect();
    super.onClose();
  }
}