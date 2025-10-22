import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/provider/ProviderChatContoller/provider_chat_list_controller.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

class ProviderChatListView extends StatelessWidget {
  const ProviderChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProviderChatListController controller = Get.put(ProviderChatListController());

    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(),
                    const Text(
                      'My Clients',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () => controller.refreshConversations(),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: (value) => controller.updateSearch(value),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search clients...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    suffixIcon: Obx(() {
                      return controller.searchText.value.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () => controller.updateSearch(''),
                      )
                          : const SizedBox.shrink();
                    }),
                    filled: true,
                    fillColor: Colors.grey[900]?.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),

              // Conversations List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (controller.conversations.isEmpty) {
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
                            controller.searchText.value.isEmpty
                                ? 'No messages yet'
                                : 'No clients found',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.searchText.value.isEmpty
                                ? 'Your clients will appear here'
                                : 'Try a different search',
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

                  return RefreshIndicator(
                    onRefresh: controller.refreshConversations,
                    color: Colors.white,
                    backgroundColor: Colors.grey[800],
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: controller.filteredConversations.length,
                      itemBuilder: (context, index) {
                        final convo = controller.filteredConversations[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[900]?.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[800]!,
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            leading: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.grey[800],
                                  backgroundImage: convo.profilePicture != null &&
                                      convo.profilePicture!.isNotEmpty
                                      ? NetworkImage(convo.imageUrl)
                                      : const AssetImage('assets/images/peopleProfile4.jpg')
                                  as ImageProvider,
                                ),
                                // Unread count badge
                                if (convo.unreadCount > 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 20,
                                        minHeight: 20,
                                      ),
                                      child: Text(
                                        convo.unreadCount > 99
                                            ? '99+'
                                            : convo.unreadCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    convo.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: convo.unreadCount > 0
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (convo.designation != null &&
                                    convo.designation!.isNotEmpty)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      convo.designation!,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                if (convo.lastMessageByMe == true)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Icon(
                                      Icons.done_all,
                                      size: 14,
                                      color: Colors.blue,
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    convo.lastMessage ?? 'No messages yet',
                                    style: TextStyle(
                                      color: convo.unreadCount > 0
                                          ? Colors.white
                                          : Colors.grey[400],
                                      fontSize: 13,
                                      fontWeight: convo.unreadCount > 0
                                          ? FontWeight.w500
                                          : FontWeight.normal,
                                      fontStyle: convo.lastMessage == null
                                          ? FontStyle.italic
                                          : FontStyle.normal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (convo.formattedTime.isNotEmpty)
                                  Text(
                                    convo.formattedTime,
                                    style: TextStyle(
                                      color: convo.unreadCount > 0
                                          ? Colors.blue
                                          : Colors.grey[500],
                                      fontSize: 11,
                                      fontWeight: convo.unreadCount > 0
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Icon(
                                  Icons.chat_bubble,
                                  color: convo.unreadCount > 0
                                      ? Colors.blue
                                      : Colors.grey[600],
                                  size: 20,
                                ),
                              ],
                            ),
                            onTap: () {
                              // Navigate to ServiceChatDetailView with USER data
                              Get.toNamed(
                                RouteName.serviceChatDetailView,
                                arguments: convo,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}