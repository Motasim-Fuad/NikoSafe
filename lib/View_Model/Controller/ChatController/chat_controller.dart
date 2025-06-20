// controller/chat_controller.dart
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../models/ChatModel/chat_model.dart';
import '../../../resource/asseets/image_assets.dart';

class ChatController extends GetxController {
  var chatList = <ChatModel>[].obs;
  var filteredChatList = <ChatModel>[].obs;
  var selectedChat = Rxn<ChatModel>();
  var messages = <ChatModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchChats();
  }

  void fetchChats() {
    final dummy = [
      ChatModel(
        message: "Hello! Need an electrician",
        name: "John Doe",
        title: "Electrician",
        time: "10:20 AM",
        imageUrl: ImageAssets.userHome_peopleProfile1,
        isSentByMe: true,
        isOnline: true,
      ),
      ChatModel(
        message: "Thank you! Task done.",
        name: "Sarah Lee",
        title: "Plumber",
        time: "9:00 AM",
        imageUrl: ImageAssets.userHome_peopleProfile2,
        isSentByMe: false,
        isOnline: false,
      ),

      ChatModel(
        message: "Thank you! Task done.",
        name: "Luke",
        title: "Painter",
        time: "9:00 AM",
        imageUrl: ImageAssets.userHome_peopleProfile2,
        isSentByMe: true,
        isOnline: true,
      ),
    ];

    chatList.value = dummy;
    filteredChatList.value = dummy;
  }

  void searchChats(String query) {
    if (query.isEmpty) {
      filteredChatList.value = chatList;
    } else {
      filteredChatList.value = chatList
          .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void openChat(ChatModel chat) {
    selectedChat.value = chat;
    messages.value = [
      ChatModel(
        message: "Hi ${chat.name}, how can I help you?",
        name: "You",
        title: "User",
        time: "11:00 AM",
        imageUrl: ImageAssets.userHome_userProfile,
        isSentByMe: true,
        isOnline: true,
      ),
      ChatModel(
        message: chat.message,
        name: chat.name,
        title: chat.title,
        time: chat.time,
        imageUrl: chat.imageUrl,
        isSentByMe: false,
        isOnline: chat.isOnline,
      ),
    ];
  }

  void sendMessage(String text, {File? imageFile, String? location}) {
    final chat = selectedChat.value;
    if (chat == null) return;

    final messageText = text.trim().isEmpty ? (location ?? "") : text;
    if (messageText.isEmpty && imageFile == null) return;

    // This part is YOU sending message, always allowed
    messages.add(ChatModel(
      message: messageText,
      name: "You",
      title: "User",
      time: "Now",
      imageUrl: ImageAssets.userHome_userProfile,
      isSentByMe: true,
      isOnline: true,
      localImageFile: imageFile,
    ));

    // Simulate a reply ONLY if other user is online
    if (chat.isOnline) {
      Future.delayed(const Duration(seconds: 1), () {
        messages.add(ChatModel(
          message: "Got it, thanks!",
          name: chat.name,
          title: chat.title,
          time: "Now",
          imageUrl: chat.imageUrl,
          isSentByMe: false,
          isOnline: chat.isOnline,
        ));
      });
    } else {
      debugPrint("${chat.name} is offline. They can't reply now.");
    }
  }


}
