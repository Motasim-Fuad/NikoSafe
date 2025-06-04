import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputField({
    required this.controller,
    required this.onSend,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          IconButton(onPressed: (){

          }, icon: CircleAvatar(
            radius: 20,
            backgroundColor: AppColor.iconColor,
            child: Icon(Icons.add,size: 15,color: AppColor.primaryTextColor,),
          )),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduced padding
                suffixIcon: IconButton(
                  onPressed: () {
                    // emoji action
                  },
                  icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.white),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          IconButton(
            icon: CircleAvatar(
              radius: 20,
              child: FaIcon(FontAwesomeIcons.solidPaperPlane,color: Color(0xff2bf8df),size: 15,),
              backgroundColor: AppColor.iconColor,
            ),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
