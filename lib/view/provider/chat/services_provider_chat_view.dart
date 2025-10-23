// Path: View/service_chat/service_chat_detail_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/provider/ProviderChatContoller/service_chat_controller.dart';
import 'package:nikosafe/models/Provider/chat/provider_chat_model.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/View/user/chat/widgets/chat_bubble.dart';
import 'package:nikosafe/View/user/chat/widgets/chat_input_field.dart';
import 'package:nikosafe/view/provider/chat/provider_chat_buble.dart';

class ServiceChatDetailView extends StatelessWidget {
  ServiceChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceChatController controller = Get.find<ServiceChatController>();
    final TextEditingController messageController = TextEditingController();
    final ScrollController scrollController = ScrollController();

    // Get provider from arguments
    final ServiceChatModel provider = Get.arguments as ServiceChatModel;

    // Open chat when view loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.openChat(provider);
    });

    return WillPopScope(
      onWillPop: () async {
        controller.closeChat();
        return true;
      },
      child: Container(
        decoration: BoxDecoration(gradient: AppColor.backGroundColor),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight + 1),
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  leading: CustomBackButton(
                    onTap: () {
                      controller.closeChat();
                      Get.back();
                    },
                  ),
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[800],
                        backgroundImage: provider.profilePicture != null &&
                            provider.profilePicture!.isNotEmpty
                            ? NetworkImage(provider.imageUrl)
                            : const AssetImage('assets/images/peopleProfile4.jpg')
                        as ImageProvider,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              provider.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Obx(() {
                              final isConnecting = controller.isConnecting.value;
                              final isConnected =
                                  controller.selectedContact.value != null;

                              return Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: isConnecting
                                          ? Colors.orange
                                          : (isConnected
                                          ? Colors.green
                                          : Colors.red),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isConnecting
                                        ? "Connecting..."
                                        : (isConnected ? "Online" : "Offline"),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
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
              Obx(() {
                if (controller.isConnecting.value) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.orange.withOpacity(0.2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Connecting to service chat...',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (controller.messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 80,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No messages yet',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start a conversation with ${provider.name}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (scrollController.hasClients) {
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  });

                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: controller.messages.length,
                    itemBuilder: (_, index) {
                      final message = controller.messages[index];
                      return ProviderChatBubble(
                        message: message,
                        onRetry: () => controller.retryMessage(message),
                      );
                    },
                  );
                }),
              ),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  border: Border(
                    top: BorderSide(color: Colors.white24, width: 0.5),
                  ),
                ),
                child: ChatInputField(
                  textController: messageController,
                  chatController: controller,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}