// Path: View_Model/Controller/user/ChatController/chat_controller.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/ChatRepo/Chat_Repositry.dart';
import 'package:nikosafe/View_Model/Services/user/chat/chat_storage_services.dart';
import 'package:nikosafe/View_Model/Services/user/chat/websocket_service.dart';
import 'package:nikosafe/models/User/ChatModel/message_model.dart';
import 'package:nikosafe/models/User/userHome/connect_user_model.dart';
import 'package:nikosafe/utils/token_manager.dart';
import 'package:nikosafe/utils/utils.dart';

class ChatController extends GetxController {
  final ChatRepo _chatRepo = ChatRepo();
  final WebSocketService _wsService = WebSocketService();

  var messages = <ChatMessage>[].obs;
  var isLoading = false.obs;
  var isConnecting = false.obs;
  var isUploading = false.obs;
  Rxn<ConnectUser> selectedFriend = Rxn<ConnectUser>();
  int? currentUserId;

  StreamSubscription? _wsSubscription; // ✅ Store subscription

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
    // ✅ Cancel previous subscription if exists
    _wsSubscription?.cancel();

    _wsSubscription = _wsService.messageStream.listen((data) {
      if (kDebugMode) print('📩 Controller received: $data');

      final messageType = data['type']?.toString();

      switch (messageType) {
        case 'connection_established':
          Utils.successSnackBar('Connected', 'Chat connected successfully');
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
          Utils.errorSnackBar('Connection Failed', 'Please check your internet');
          isConnecting.value = false;
          break;
      }
    });
  }

  void _handleIncomingMessage(Map<String, dynamic> data) {
    if (currentUserId == null) return;

    try {
      // Extract the message data - might be nested
      final messageData = data['message'] ?? data;

      final message = ChatMessage.fromJson(messageData, currentUserId!);

      // Check if message belongs to current chat
      final isFromCurrentChat = (message.senderId == selectedFriend.value?.id &&
          message.receiverId == currentUserId) ||
          (message.senderId == currentUserId &&
              message.receiverId == selectedFriend.value?.id);

      if (isFromCurrentChat) {
        messages.add(message);

        if (kDebugMode) {
          print('✅ Message added: ${message.displayText}');
          print('Type: ${message.type}, FileURL: ${message.fileUrl}');
        }

        // Save last message
        final friendId = message.isSentByMe ? message.receiverId : message.senderId;
        ChatStorageService.saveLastMessage(
          friendId: friendId,
          message: message.displayText,
          timestamp: message.timestamp.toIso8601String(),
          isSentByMe: message.isSentByMe,
        );
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error handling incoming message: $e');
    }
  }

  void _handleMessageSent(Map<String, dynamic> data) {
    final tempId = data['temp_id'];
    final serverId = data['id'];
    final message = data['message'];

    final index = messages.indexWhere((m) => m.id == tempId);
    if (index != -1) {
      messages[index] = messages[index].copyWith(
        id: serverId,
        status: MessageStatus.sent,
      );
    }

    if (message != null && selectedFriend.value != null) {
      ChatStorageService.saveLastMessage(
        friendId: selectedFriend.value!.id,
        message: message['text'] ?? '📎 Attachment',
        timestamp: DateTime.now().toIso8601String(),
        isSentByMe: true,
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

  Future<void> openChat(ConnectUser friend) async {
    selectedFriend.value = friend;
    messages.clear();

    if (kDebugMode) print('Opening chat with: ${friend.name} (ID: ${friend.id})');

    try {
      isConnecting.value = true;
      await _wsService.connect(friend.id);
      await _loadChatHistory(friend.id);
      isConnecting.value = false;
    } catch (e) {
      isConnecting.value = false;
      if (kDebugMode) print('❌ Error opening chat: $e');
      Utils.errorSnackBar('Error', 'Failed to connect to chat');
    }
  }

  Future<void> _loadChatHistory(int friendId) async {
    try {
      isLoading.value = true;

      final response = await _chatRepo.getChatHistory(friendId: friendId);

      if (response['success'] == true && response['data'] != null) {
        List<dynamic> messagesJson = response['data'] as List;

        messages.value = messagesJson
            .map((json) => ChatMessage.fromJson(json, currentUserId!))
            .toList();

        if (kDebugMode) print('✅ Loaded ${messages.length} messages');
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Could not load chat history: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendTextMessage(String text) async {
    if (text.trim().isEmpty || selectedFriend.value == null) return;

    final tempId = DateTime.now().millisecondsSinceEpoch;

    final message = ChatMessage(
      id: tempId,
      senderId: currentUserId!,
      receiverId: selectedFriend.value!.id,
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
      if (kDebugMode) print('❌ Error sending message: $e');

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
    if (selectedFriend.value == null) return;
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
      receiverId: selectedFriend.value!.id,
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

        final uploadResponse = await _chatRepo.uploadChatFile(
          file: file,
          receiverId: selectedFriend.value!.id,
          text: text,
        );

        isUploading.value = false;

        if (uploadResponse['success'] == true && uploadResponse['data'] != null) {
          final fileData = uploadResponse['data'];

          final updatedMessage = message.copyWith(
            fileUrl: fileData['file'],
          );

          // ✅ Fix: Simpler WebSocket payload
          final wsPayload = {
            'type': 'send_message',
            'receiver_id': selectedFriend.value!.id,
            'message': text?.trim() ?? '📎 Attachment',
            'file_url': fileData['file'],
            'file_name': fileData['file_name'] ?? 'file',
            'file_type': fileData['message_type'] ?? 'image',
          };

          _wsService.sendMessage(wsPayload);

          final index = messages.indexWhere((m) => m.id == tempId);
          if (index != -1) {
            messages[index] = updatedMessage.copyWith(status: MessageStatus.sent);
          }
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
      if (kDebugMode) print('❌ Error sending file message: $e');

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
    if (selectedFriend.value == null) return;

    final tempId = DateTime.now().millisecondsSinceEpoch;

    final message = ChatMessage(
      id: tempId,
      senderId: currentUserId!,
      receiverId: selectedFriend.value!.id,
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
        'receiver_id': selectedFriend.value!.id,
        'message': locationName ?? 'Shared Location',
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
      if (kDebugMode) print('❌ Error sending location: $e');

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
    selectedFriend.value = null;
  }

  @override
  void onClose() {
    _wsSubscription?.cancel(); // ✅ Cancel subscription
    _wsService.disconnect();
    super.onClose();
  }
}