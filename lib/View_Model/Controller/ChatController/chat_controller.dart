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
    final dummyData = [
      ChatModel(
        name: 'Hande Earcel',
        message: 'Good morning! Thank you for reaching...',
        title:"Electrician",
        time: '9:30',
        imageUrl: ImageAssets.userHome_peopleProfile2,
        isOnline: true,

      ),
      ChatModel(
        name: 'Emily Carter',
        message: 'Can we reschedule the service?',
        title: "User",
        time: '10:15',
        imageUrl: ImageAssets.userHome_userProfile,
        isOnline: false,
      ),
      ChatModel(
        name: 'Alex Smith',
        message: 'Job completed successfully!',
        title: "Plumber",
        time: 'Yesterday',
        imageUrl: ImageAssets.userHome_peopleProfile1,
        isOnline: true,
      ),
    ];

    chatList.value = dummyData;
    filteredChatList.value = dummyData;
  }

  void searchChats(String query) {
    if (query.isEmpty) {
      filteredChatList.value = chatList;
    } else {
      filteredChatList.value = chatList
          .where((chat) => chat.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void openChat(ChatModel chat) {
    selectedChat.value = chat;
    messages.value = [
      ChatModel(
        message: "Hi there, thanks for reaching out...",
        name: chat.name,
        title: chat.title,
        time: "11:30 AM",
        imageUrl: chat.imageUrl,
        isSentByMe: true,

      ),
      ChatModel(
        message: "Looking forward to the service!",
        name: "You",

        time: "11:45 AM",
        imageUrl: ImageAssets.userHome_userProfile,
        isSentByMe: true,
        title: "user",
      ),
    ];
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Add user message
    messages.add(ChatModel(
      message: text,
      name: "You",
      time: "Now",
      imageUrl: ImageAssets.userHome_userProfile,
      isSentByMe: true,
      title: 'User',
    ));

    final otherUser = selectedChat.value!;

    // Only reply if other user is online
    if (otherUser.isOnline == true) {
      Future.delayed(const Duration(seconds: 1), () {
        messages.add(ChatModel(
          message: "Thanks for your message! I'll get back to you shortly.",
          name: otherUser.name,
          time: "Now",
          imageUrl: otherUser.imageUrl,
          isSentByMe: false,
          title: otherUser.title,
        ));
      });
    }
  }


}
