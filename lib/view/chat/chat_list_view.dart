import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/view/chat/widgets/chat_list_title.dart';
import '../../View_Model/Controller/ChatController/chat_controller.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';

class ChatListView extends StatelessWidget {
  final controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A36),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:  Text('Chat',style: TextStyle(color: AppColor.primaryTextColor),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: controller.searchChats,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search user...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.filteredChatList.length,
                itemBuilder: (context, index) {
                  final chat = controller.filteredChatList[index];
                  return ChatListTile(
                    chat: chat,
                    onTap: () {
                      controller.openChat(chat);
                      Get.toNamed(RouteName.chatDetailView);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
