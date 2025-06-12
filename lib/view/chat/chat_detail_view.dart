import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/view/chat/widgets/chat_bubble.dart';
import 'package:nikosafe/view/chat/widgets/chat_input_field.dart';
import '../../View_Model/Controller/ChatController/chat_controller.dart';
import '../../resource/compunents/customBackButton.dart';

class ChatDetailView extends StatelessWidget {
  final controller = Get.find<ChatController>();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chat = controller.selectedChat.value!;
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,

          automaticallyImplyLeading: false,
          leading: CustomBackButton(),

          iconTheme: const IconThemeData(color: Colors.white), // <-- White back button
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(chat.imageUrl), // <-- Use AssetImage for local asset
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: const TextStyle(fontSize: 16, color: AppColor.primaryTextColor),
                  ),
                  Text(
                    chat.title,
                    style: const TextStyle(fontSize: 12, color: AppColor.secondaryTextColor),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 4, top: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: chat.isOnline ? Colors.green : Colors.grey,
                        ),
                      ),
                      Text(
                        chat.isOnline ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontSize: 10,
                          color: chat.isOnline ? Colors.greenAccent : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            ],
          ),
          actions: const [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.call, color: Colors.tealAccent),
            ),
            SizedBox(width: 10),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Wednesday, July 26th',
              style: TextStyle(color: AppColor.secondaryTextColor, fontSize: 12),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) =>
                    ChatBubble(message: controller.messages[index]),
              )),
            ),
            ChatInputField(
              controller: messageController,
              onSend: () {
                controller.sendMessage(messageController.text);
                messageController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
