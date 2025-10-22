// Path: View_Model/Controller/vendor/vendor_chat_controller.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/vendor_repo/chat_repo/vendor_chat_repo.dart';
import 'package:nikosafe/View_Model/Services/vendor/vendor_websocket_service.dart';
import 'package:nikosafe/models/User/ChatModel/message_model.dart';
import 'package:nikosafe/models/vendor/chat/vendor_chat_model.dart';
import 'package:nikosafe/resource/App_Url/app_url.dart';
import 'package:nikosafe/utils/token_manager.dart';
import 'package:nikosafe/utils/utils.dart';

class VendorChatController extends GetxController {
  final VendorChatRepo _chatRepo = VendorChatRepo();
  final VendorWebSocketService _wsService = VendorWebSocketService();

  var messages = <ChatMessage>[].obs;
  var isLoading = false.obs;
  var isConnecting = false.obs;
  var isUploading = false.obs;
  Rxn<VendorChatModel> selectedVendor = Rxn<VendorChatModel>();
  int? currentUserId;

  StreamSubscription? _wsSubscription;

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
          _updateMessageStatus(data['message_id'], MessageStatus.delivered);
          break;

        case 'message_read':
          _updateMessageStatus(data['message_id'], MessageStatus.read);
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

      final message = ChatMessage.fromJson(
        messageData,
        currentUserId!,
        baseUrl: AppUrl.base_url,
      );

      // Check if message belongs to current vendor chat
      final isFromCurrentChat = (message.senderId == selectedVendor.value?.id &&
          message.receiverId == currentUserId) ||
          (message.senderId == currentUserId &&
              message.receiverId == selectedVendor.value?.id);

      if (isFromCurrentChat) {
        messages.add(message);

        if (kDebugMode) {
          print('✅ Vendor message added: ${message.displayText}');
        }
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error handling vendor message: $e');
    }
  }

  void _handleMessageSent(Map<String, dynamic> data) {
    final tempId = data['temp_id'];
    final serverId = data['id'];

    final index = messages.indexWhere((m) => m.id == tempId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(
        id: serverId,
        status: MessageStatus.sent,
      );
    }
  }

  void _updateMessageStatus(int? messageId, MessageStatus status) {
    if (messageId == null) return;

    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(status: status);
    }
  }

  Future<void> openChat(VendorChatModel vendor) async {
    selectedVendor.value = vendor;
    messages.clear();

    if (kDebugMode) print('Opening vendor chat: ${vendor.name} (ID: ${vendor.id})');

    try {
      isConnecting.value = true;
      await _wsService.connect(vendor.id);
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

      if (response['success'] == true && response['data'] != null) {
        List<dynamic> messagesJson = response['data'] as List;

        messages.value = messagesJson
            .map((json) => ChatMessage.fromJson(
          json,
          currentUserId!,
          baseUrl: AppUrl.base_url,
        ))
            .toList();

        if (kDebugMode) print('✅ Loaded ${messages.length} vendor messages');
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Could not load vendor chat history: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendTextMessage(String text) async {
    if (text.trim().isEmpty || selectedVendor.value == null) return;

    final tempId = DateTime.now().millisecondsSinceEpoch;

    final message = ChatMessage(
      id: tempId,
      senderId: currentUserId!,
      receiverId: selectedVendor.value!.id,
      text: text.trim(),
      type: MessageType.text,
      status: MessageStatus.sending,
      timestamp: DateTime.now(),
      isSentByMe: true,
    );

    messages.add(message);

    try {
      _wsService.sendMessage(message.toJson());

      final index = messages.indexWhere((m) => m.id == tempId);
      if (index != -1) {
        messages[index] = message.copyWith(status: MessageStatus.sent);
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error sending vendor message: $e');

      final index = messages.indexWhere((m) => m.id == tempId);
      if (index != -1) {
        messages[index] = message.copyWith(
          status: MessageStatus.failed,
          errorMessage: 'Failed to send',
        );
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

    MessageType messageType = MessageType.text;
    if (file != null) {
      final extension = file.path.split('.').last.toLowerCase();
      if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
        messageType = MessageType.image;
      } else if (['mp4', 'mov', 'avi', 'mkv'].contains(extension)) {
        messageType = MessageType.video;
      } else {
        messageType = MessageType.file;
      }
    }

    final message = ChatMessage(
      id: tempId,
      senderId: currentUserId!,
      receiverId: selectedVendor.value!.id,
      text: text?.trim(),
      type: messageType,
      status: MessageStatus.sending,
      timestamp: DateTime.now(),
      isSentByMe: true,
      localFile: file,
    );

    messages.add(message);

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

          final index = messages.indexWhere((m) => m.id == tempId);
          if (index != -1) {
            messages[index] = ChatMessage.fromJson(
              fileData,
              currentUserId!,
              baseUrl: AppUrl.base_url,
            );
          }

          _wsService.sendMessage({
            'type': 'file_uploaded',
            'receiver_id': selectedVendor.value!.id,
            'message_id': fileData['id'],
          });
        } else {
          throw Exception('File upload failed');
        }
      } else {
        _wsService.sendMessage(message.toJson());

        final index = messages.indexWhere((m) => m.id == tempId);
        if (index != -1) {
          messages[index] = message.copyWith(status: MessageStatus.sent);
        }
      }
    } catch (e) {
      isUploading.value = false;
      if (kDebugMode) print('❌ Error sending vendor file: $e');

      final index = messages.indexWhere((m) => m.id == tempId);
      if (index != -1) {
        messages[index] = message.copyWith(
          status: MessageStatus.failed,
          errorMessage: 'Failed to send',
        );
      }

      Utils.errorSnackBar('Error', 'Failed to send file');
    }
  }

  Future<void> sendLocation({
    required double latitude,
    required double longitude,
    String? locationName,
  }) async {
    if (selectedVendor.value == null) return;

    final tempId = DateTime.now().millisecondsSinceEpoch;
    final locationUrl = 'https://maps.google.com/?q=$latitude,$longitude';
    final messageText = '${locationName ?? 'Shared Location'}\n$locationUrl';

    final message = ChatMessage(
      id: tempId,
      senderId: currentUserId!,
      receiverId: selectedVendor.value!.id,
      text: messageText,
      type: MessageType.location,
      status: MessageStatus.sending,
      timestamp: DateTime.now(),
      isSentByMe: true,
      latitude: latitude,
      longitude: longitude,
      locationName: locationName ?? 'Shared Location',
    );

    messages.add(message);

    try {
      final wsPayload = {
        'type': 'send_message',
        'receiver_id': selectedVendor.value!.id,
        'message': messageText,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'location_name': locationName ?? 'Shared Location',
      };

      _wsService.sendMessage(wsPayload);

      final index = messages.indexWhere((m) => m.id == tempId);
      if (index != -1) {
        messages[index] = message.copyWith(status: MessageStatus.sent);
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error sending vendor location: $e');

      final index = messages.indexWhere((m) => m.id == tempId);
      if (index != -1) {
        messages[index] = message.copyWith(
          status: MessageStatus.failed,
          errorMessage: 'Failed to send',
        );
      }

      Utils.errorSnackBar('Error', 'Failed to send location');
    }
  }

  void retryMessage(ChatMessage message) {
    if (message.status != MessageStatus.failed) return;

    messages.removeWhere((m) => m.id == message.id);

    if (message.type == MessageType.text) {
      sendTextMessage(message.text ?? '');
    } else if (message.localFile != null) {
      sendFileMessage(file: message.localFile, text: message.text);
    } else if (message.type == MessageType.location) {
      sendLocation(
        latitude: message.latitude!,
        longitude: message.longitude!,
        locationName: message.locationName,
      );
    }
  }

  void closeChat() {
    messages.clear();
    selectedVendor.value = null;
  }

  @override
  void onClose() {
    _wsSubscription?.cancel();
    _wsService.disconnect();
    super.onClose();
  }
}