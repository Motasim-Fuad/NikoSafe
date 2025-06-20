import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../View_Model/Controller/ChatController/chat_input_controller.dart';
import '../../../resource/Colors/app_colors.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String text, File? imageOrVideo, String? location) onSend;
  final inputController = Get.put(ChatInputController());

  ChatInputField({required this.controller, required this.onSend, super.key});

  void _handleSend() {
    onSend(
      controller.text,
      inputController.selectedMedia.value,
      inputController.selectedLocation?.value,
    );
    controller.clear();
    inputController.clear();
  }

  void _showAttachmentMenu(BuildContext context) async {
    final selected = await showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(100, 600, 20, 0), // Customize as needed
      color: AppColor.topLinear,
      items: [
        PopupMenuItem<String>(
          value: 'Gallery',
          child: Row(
            children: const [
              Icon(Icons.photo, color: Colors.white),
              SizedBox(width: 10),
              Text("Gallery", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'Share Location',
          child: Row(
            children: const [
              Icon(Icons.location_on, color: Colors.white),
              SizedBox(width: 10),
              Text("Share Location", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );

    if (selected == 'Gallery') {
      await inputController.pickMedia();
    } else if (selected == 'Share Location') {
      await inputController.shareLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          final file = inputController.selectedMedia.value;
          return file != null
              ? Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(file),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Positioned(
                right: 4,
                top: 4,
                child: GestureDetector(
                  onTap: () => inputController.selectedMedia.value = null,
                  child: const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          )
              : const SizedBox.shrink();
        }),
        Obx(() {
          final location = inputController.selectedLocation?.value;
          return location != null
              ? Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => inputController.selectedLocation?.value = null,
                ),
              ],
            ),
          )
              : const SizedBox.shrink();
        }),
        Row(
          children: [
            IconButton(
              icon: CircleAvatar(
                radius: 20,
                backgroundColor: AppColor.iconColor,
                child: Icon(Icons.add, size: 15, color: AppColor.primaryTextColor),
              ),
              onPressed: () => _showAttachmentMenu(context),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0x33236d76),
                  hintText: "Message",
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.white),
                    onPressed: inputController.toggleEmojiPicker,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            IconButton(
              icon: CircleAvatar(
                radius: 20,
                backgroundColor: AppColor.iconColor,
                child: const FaIcon(FontAwesomeIcons.solidPaperPlane, size: 15, color: Color(0xff2bf8df)),
              ),
              onPressed: _handleSend,
            ),
          ],
        ),
        Obx(() => inputController.showEmojiPicker.value
            ? SizedBox(
          height: 250,
          child:
          EmojiPicker(
            onEmojiSelected: (category ,emoji) {
              controller.text += emoji.emoji;
            },
            config: Config(
              emojiViewConfig: EmojiViewConfig(
                emojiSizeMax: 28,
                columns: 7,
              ),
              categoryViewConfig: CategoryViewConfig(
                backgroundColor: Colors.black,
                iconColorSelected: Colors.teal,
              ),
              skinToneConfig: SkinToneConfig(),
            ),
          ),
        )
            : const SizedBox.shrink(

        )),
      ],
    );
  }
}
