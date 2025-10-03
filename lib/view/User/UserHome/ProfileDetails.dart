// Path: View/user/userHome/ProfileDetailsPage.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userHome/profile_details_controller.dart';
import 'package:nikosafe/models/User/userHome/connect_user_model.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import '../../../View_Model/Controller/user/userHome/connectController.dart';

import '../../../resource/Colors/app_colors.dart';
import '../../../resource/compunents/RoundButton.dart';

class ProfileDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConnectController connectController = Get.find<ConnectController>();
    final ProfileDetailsController controller = Get.put(ProfileDetailsController());

    final dynamic user = Get.arguments;
    if (user is! ConnectUser) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text("Invalid user data", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    // Load user posts when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadUserPosts(user.postIds);
    });

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
                      'Profile Details',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.more_horiz, color: Colors.white),
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      // Profile Picture
                      CircleAvatar(
                        backgroundImage: user.profilePicture != null && user.profilePicture!.isNotEmpty
                            ? NetworkImage(user.imageUrl)
                            : const AssetImage('assets/images/peopleProfile4.jpg')
                        as ImageProvider,
                        radius: 45,
                        backgroundColor: Colors.grey[800],
                      ),
                      const SizedBox(height: 10),

                      // Name
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 4),
                      // Email
                      Text(
                        user.email,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),

                      const SizedBox(height: 16),

                      // Connect Button
                      Obx(() {
                        final currentUser = connectController.allConnections
                            .firstWhereOrNull((u) => u.id == user.id);

                        final friendshipStatus = currentUser?.friendshipStatus ?? user.friendshipStatus;
                        final buttonText = connectController.getConnectionButtonText(friendshipStatus);
                        final isButtonEnabled = connectController.isConnectionButtonEnabled(friendshipStatus);

                        return RoundButton(
                          onPress: isButtonEnabled
                              ? () => connectController.sendFriendRequest(user.id, user.name)
                              : () {},
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.4,
                          title: buttonText,
                        );
                      }),

                      const SizedBox(height: 16),

                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${user.postCount}",
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          const Text("Posts", style: TextStyle(color: Colors.grey)),
                          const SizedBox(width: 20),
                          Text(
                            "${user.connectCount}",
                            style: const TextStyle(
                                color: Colors.greenAccent, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          const Text("Connect", style: TextStyle(color: Colors.grey)),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Posts Grid
                      Obx(() {
                        if (controller.isLoading.value) {
                          return Container(
                            height: 300,
                            child: const Center(
                              child: CircularProgressIndicator(color: Colors.white),
                            ),
                          );
                        }

                        if (user.postIds.isEmpty || controller.userPosts.isEmpty) {
                          return Container(
                            height: 300,
                            child: const Center(
                              child: Text(
                                'No posts yet',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.userPosts.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              final post = controller.userPosts[index];

                              // Extract image URL properly - handle both String and Map
                              String? imageUrl;
                              if (post.images.isNotEmpty) {
                                final firstImage = post.images[0];
                                if (firstImage is String) {
                                  imageUrl = firstImage;
                                } else if (firstImage is Map) {
                                  imageUrl = firstImage['url'] ?? firstImage['image'] ?? firstImage['src'];
                                }
                              }

                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: imageUrl != null && imageUrl.isNotEmpty
                                    ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[800],
                                      child: const Icon(Icons.image,
                                          color: Colors.grey),
                                    );
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey[800],
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                )
                                    : Container(
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.article,
                                      color: Colors.grey, size: 30),
                                ),
                              );
                            },
                          ),
                        );
                      }),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}