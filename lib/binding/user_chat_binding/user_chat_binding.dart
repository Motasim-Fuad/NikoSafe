// Path: binding/chat/chat_binding.dart
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/ChatController/chat_controller.dart';
import 'package:nikosafe/View_Model/Controller/user/ChatController/chat_input_controller.dart';
import 'package:nikosafe/View_Model/Controller/user/ChatController/chat_list_view_controller.dart';

class UserChatBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ Lazy put - only create when needed
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<ChatInputController>(() => ChatInputController());
  }
}

class UserChatListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatListController>(() => ChatListController());
  }
}