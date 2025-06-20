// view/chat/chat_detail_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/view/chat/widgets/chat_bubble.dart';
import 'package:nikosafe/view/chat/widgets/chat_input_field.dart';
import '../../View_Model/Controller/ChatController/chat_controller.dart';
import '../../resource/Colors/app_colors.dart';

class ChatDetailView extends StatelessWidget {
  final controller = Get.put(ChatController());
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chat = controller.selectedChat.value!;
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 1), // +1 for the line
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leading: CustomBackButton(),
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(chat.imageUrl),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(chat.name, style: const TextStyle(color: Colors.white70)),
                        Row(
                          children: [
                            const SizedBox(width: 2),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: chat.isOnline ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              chat.isOnline ? "Online" : "Offline",
                              style: const TextStyle(fontSize: 12, color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ✅ This is your white line
              const Divider(
                color: Colors.white24,
                thickness: 0.8,
                height: 0,
              ),
            ],
          ),
        ),

        body: Column(
          children: [
            Expanded(
              child: Obx(() => ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.messages.length,
                itemBuilder: (_, index) => ChatBubble(
                  message: controller.messages[index],
                ),
              )),
            ),
            ChatInputField(
              controller: messageController,
              onSend: (text, image, location) =>
                  controller.sendMessage(text, imageFile: image, location: location),

            ),
          ],
        ),
      ),
    );
  }
}
