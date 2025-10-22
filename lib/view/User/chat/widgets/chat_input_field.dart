// // Path: View/user/chat/widgets/chat_input_field.dart
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:nikosafe/View_Model/Controller/user/ChatController/chat_controller.dart';
// import 'package:nikosafe/View_Model/Controller/user/ChatController/chat_input_controller.dart';
// import 'package:nikosafe/resource/Colors/app_colors.dart';
//
// class ChatInputField extends StatelessWidget {
//   final TextEditingController textController;
//   final ChatController chatController;
//   final ChatInputController inputController = Get.put(ChatInputController());
//
//   ChatInputField({
//     required this.textController,
//     required this.chatController,
//     super.key,
//   });
//
//
//   void _handleSend() async {
//     final text = textController.text.trim();
//     final file = inputController.selectedMedia.value;
//     final location = inputController.selectedLocation?.value;
//
//     // Don't send if everything is empty
//     if (text.isEmpty && file == null && location == null) return;
//
//     // ✅ NEW - Check which controller type we have
//     final controller = chatController;
//
//     // If there's a file, use sendFileMessage
//     if (file != null) {
//       await controller.sendFileMessage(
//         file: file,
//         text: text.isNotEmpty ? text : null,
//       );
//     }
//     // If there's a location, send it
//     else if (location != null) {
//       final parts = location.split('q=');
//       if (parts.length == 2) {
//         final coords = parts[1].split(',');
//         if (coords.length == 2) {
//           await controller.sendLocation(
//             latitude: double.parse(coords[0]),
//             longitude: double.parse(coords[1]),
//             locationName: 'Shared Location',
//           );
//         }
//       }
//     }
//     // Otherwise just send text
//     else if (text.isNotEmpty) {
//       await controller.sendTextMessage(text);
//     }
//
//     // Clear everything
//     textController.clear();
//     inputController.clear();
//   }
//   // void _handleSend() async {
//   //   final text = textController.text.trim();
//   //   final file = inputController.selectedMedia.value;
//   //   final location = inputController.selectedLocation?.value;
//   //
//   //   // Don't send if everything is empty
//   //   if (text.isEmpty && file == null && location == null) return;
//   //
//   //   // If there's a file, use sendFileMessage
//   //   if (file != null) {
//   //     await chatController.sendFileMessage(
//   //       file: file,
//   //       text: text.isNotEmpty ? text : null,
//   //     );
//   //   }
//   //   // If there's a location, send it
//   //   else if (location != null) {
//   //     final parts = location.split('q=');
//   //     if (parts.length == 2) {
//   //       final coords = parts[1].split(',');
//   //       if (coords.length == 2) {
//   //         await chatController.sendLocation(
//   //           latitude: double.parse(coords[0]),
//   //           longitude: double.parse(coords[1]),
//   //           locationName: 'Shared Location',
//   //         );
//   //       }
//   //     }
//   //   }
//   //   // Otherwise just send text
//   //   else if (text.isNotEmpty) {
//   //     await chatController.sendTextMessage(text);
//   //   }
//   //
//   //   // Clear everything
//   //   textController.clear();
//   //   inputController.clear();
//   // }
//
//   Widget _attachmentMenu(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 5),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: AppColor.topLinear,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: const [
//           BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
//         ],
//       ),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.5,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             GestureDetector(
//               onTap: () async {
//                 await inputController.pickMedia();
//                 inputController.isAttachmentMenuOpen.value = false;
//               },
//               child: Row(
//                 children: const [
//                   Icon(Icons.photo, color: Colors.white),
//                   SizedBox(width: 10),
//                   Text("Gallery", style: TextStyle(color: Colors.white)),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Divider(),
//             const SizedBox(height: 10),
//             GestureDetector(
//               onTap: () async {
//                 await inputController.shareLocation();
//                 inputController.isAttachmentMenuOpen.value = false;
//               },
//               child: Row(
//                 children: const [
//                   Icon(Icons.location_on, color: Colors.white),
//                   SizedBox(width: 10),
//                   Text("Share Location", style: TextStyle(color: Colors.white)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Media preview
//         Obx(() {
//           final file = inputController.selectedMedia.value;
//           return file != null
//               ? Stack(
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(bottom: 8),
//                 height: 150,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: FileImage(file),
//                     fit: BoxFit.cover,
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               Positioned(
//                 right: 4,
//                 top: 4,
//                 child: GestureDetector(
//                   onTap: () => inputController.selectedMedia.value = null,
//                   child: const CircleAvatar(
//                     radius: 14,
//                     backgroundColor: Colors.black54,
//                     child: Icon(Icons.close, size: 16, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           )
//               : const SizedBox.shrink();
//         }),
//
//         // Location preview
//         Obx(() {
//           final location = inputController.selectedLocation?.value;
//           return location != null
//               ? Container(
//             margin: const EdgeInsets.only(bottom: 8),
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.black26,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               children: [
//                 const Icon(Icons.location_on, color: Colors.white),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     location,
//                     style: const TextStyle(color: Colors.white),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close, color: Colors.white),
//                   onPressed: () =>
//                   inputController.selectedLocation?.value = null,
//                 ),
//               ],
//             ),
//           )
//               : const SizedBox.shrink();
//         }),
//
//         // Uploading indicator
//         Obx(() {
//           return chatController.isUploading.value
//               ? Container(
//             margin: const EdgeInsets.only(bottom: 8),
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.blue.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               children: const [
//                 SizedBox(
//                   width: 16,
//                   height: 16,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Text(
//                   'Uploading file...',
//                   style: TextStyle(color: Colors.white70),
//                 ),
//               ],
//             ),
//           )
//               : const SizedBox.shrink();
//         }),
//
//         // Dropdown menu (shown above input)
//         Obx(() => inputController.isAttachmentMenuOpen.value
//             ? Padding(
//           padding: const EdgeInsets.only(bottom: 8),
//           child: _attachmentMenu(context),
//         )
//             : const SizedBox.shrink()),
//
//         // Main input row
//         Row(
//           children: [
//             Obx(() => IconButton(
//               icon: CircleAvatar(
//                 radius: 20,
//                 backgroundColor: AppColor.iconColor,
//                 child: Icon(
//                   inputController.isAttachmentMenuOpen.value
//                       ? Icons.keyboard_arrow_down
//                       : Icons.add,
//                   size: 20,
//                   color: AppColor.primaryTextColor,
//                 ),
//               ),
//               onPressed: () {
//                 inputController.toggleAttachmentMenu();
//               },
//             )),
//             const SizedBox(width: 8),
//             Expanded(
//               child: TextField(
//                 controller: textController,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: const Color(0x33236d76),
//                   hintText: "Message",
//                   hintStyle: const TextStyle(color: Colors.white54),
//                   border: const OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                     borderSide: BorderSide.none,
//                   ),
//                   contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.emoji_emotions_outlined,
//                         color: Colors.white),
//                     onPressed: inputController.toggleEmojiPicker,
//                   ),
//                 ),
//                 style: const TextStyle(color: Colors.white),
//                 maxLines: null,
//               ),
//             ),
//             IconButton(
//               icon: CircleAvatar(
//                 radius: 20,
//                 backgroundColor: AppColor.iconColor,
//                 child: const FaIcon(
//                   FontAwesomeIcons.solidPaperPlane,
//                   size: 15,
//                   color: Color(0xff2bf8df),
//                 ),
//               ),
//               onPressed: _handleSend,
//             ),
//           ],
//         ),
//
//         // Emoji picker
//         Obx(() => inputController.showEmojiPicker.value
//             ? SizedBox(
//           height: 250,
//           child: EmojiPicker(
//             onEmojiSelected: (category, emoji) {
//               textController.text += emoji.emoji;
//             },
//             config: Config(
//               emojiViewConfig: EmojiViewConfig(
//                 emojiSizeMax: 28,
//                 columns: 7,
//               ),
//               categoryViewConfig: CategoryViewConfig(
//                 backgroundColor: Colors.black,
//                 iconColorSelected: Colors.teal,
//               ),
//               skinToneConfig: SkinToneConfig(),
//             ),
//           ),
//         )
//             : const SizedBox.shrink()),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nikosafe/View_Model/Controller/user/ChatController/chat_input_controller.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController textController;
  final dynamic chatController;
  final ChatInputController inputController = Get.put(ChatInputController());

  ChatInputField({
    required this.textController,
    required this.chatController,
    super.key,
  });

  void _handleSend() async {
    final text = textController.text.trim();
    final file = inputController.selectedMedia.value;
    final location = inputController.selectedLocation?.value;

    // Don't send if everything is empty
    if (text.isEmpty && file == null && location == null) return;

    // If there's a file, use sendFileMessage
    if (file != null) {
      await chatController.sendFileMessage(
        file: file,
        text: text.isNotEmpty ? text : null,
      );
    }
    // If there's a location, send it
    else if (location != null) {
      final parts = location.split('q=');
      if (parts.length == 2) {
        final coords = parts[1].split(',');
        if (coords.length == 2) {
          await chatController.sendLocation(
            latitude: double.parse(coords[0]),
            longitude: double.parse(coords[1]),
            locationName: 'Shared Location',
          );
        }
      }
    }
    // Otherwise just send text
    else if (text.isNotEmpty) {
      await chatController.sendTextMessage(text);
    }

    // Clear everything
    textController.clear();
    inputController.clear();
  }

  Widget _attachmentMenu(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.topLinear,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                await inputController.pickMedia();
                inputController.isAttachmentMenuOpen.value = false;
              },
              child: Row(
                children: const [
                  Icon(Icons.photo, color: Colors.white),
                  SizedBox(width: 10),
                  Text("Gallery", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                await inputController.shareLocation();
                inputController.isAttachmentMenuOpen.value = false;
              },
              child: Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.white),
                  SizedBox(width: 10),
                  Text("Share Location", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Media preview
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

        // Location preview
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
                  onPressed: () =>
                  inputController.selectedLocation?.value = null,
                ),
              ],
            ),
          )
              : const SizedBox.shrink();
        }),

        // Uploading indicator
        Obx(() {
          return chatController.isUploading.value
              ? Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Uploading file...',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          )
              : const SizedBox.shrink();
        }),

        // Dropdown menu
        Obx(() => inputController.isAttachmentMenuOpen.value
            ? Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _attachmentMenu(context),
        )
            : const SizedBox.shrink()),

        // Main input row
        Row(
          children: [
            Obx(() => IconButton(
              icon: CircleAvatar(
                radius: 20,
                backgroundColor: AppColor.iconColor,
                child: Icon(
                  inputController.isAttachmentMenuOpen.value
                      ? Icons.keyboard_arrow_down
                      : Icons.add,
                  size: 20,
                  color: AppColor.primaryTextColor,
                ),
              ),
              onPressed: () {
                inputController.toggleAttachmentMenu();
              },
            )),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0x33236d76),
                  hintText: "Message",
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined,
                        color: Colors.white),
                    onPressed: inputController.toggleEmojiPicker,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: null,
              ),
            ),
            IconButton(
              icon: CircleAvatar(
                radius: 20,
                backgroundColor: AppColor.iconColor,
                child: const FaIcon(
                  FontAwesomeIcons.solidPaperPlane,
                  size: 15,
                  color: Color(0xff2bf8df),
                ),
              ),
              onPressed: _handleSend,
            ),
          ],
        ),

        // Emoji picker
        Obx(() => inputController.showEmojiPicker.value
            ? SizedBox(
          height: 250,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              textController.text += emoji.emoji;
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
            : const SizedBox.shrink()),
      ],
    );
  }
}
