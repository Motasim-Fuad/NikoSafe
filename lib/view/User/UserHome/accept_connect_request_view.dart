// Path: View/user/userHome/AcceptConnectRequestView.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userHome/accept_connect_request_controller.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

class AcceptConnectRequestView extends StatelessWidget {
  const AcceptConnectRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final AcceptConnectController controller = Get.put(AcceptConnectController());

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
                      'Friend Requests',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // Friend Requests List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (controller.friendRequests.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 80,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No friend requests',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'When someone sends you a request,\nit will appear here',
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
                    onRefresh: controller.loadFriendRequests,
                    color: Colors.white,
                    backgroundColor: Colors.grey[800],
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: controller.friendRequests.length,
                      itemBuilder: (context, index) {
                        final request = controller.friendRequests[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[900]?.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[800]!,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Profile Picture
                              GestureDetector(
                                onTap: () => controller.viewProfile(request),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey[800],
                                  backgroundImage: request.profilePicture != null &&
                                      request.profilePicture!.isNotEmpty
                                      ? NetworkImage(request.imageUrl)
                                      : const AssetImage('assets/images/peopleProfile4.jpg')
                                  as ImageProvider,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Name and Message
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => controller.viewProfile(request),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        request.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'wants to connect with you',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Action Buttons
                              Column(
                                children: [
                                  // Accept Button
                                  Material(
                                    color: Colors.greenAccent,
                                    borderRadius: BorderRadius.circular(8),
                                    child: InkWell(
                                      onTap: () => controller.acceptFriendRequest(
                                        request.id,
                                        request.name,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        child: const Text(
                                          'Accept',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Decline Button
                                  Material(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(8),
                                    child: InkWell(
                                      onTap: () => controller.declineFriendRequest(
                                        request.id,
                                        request.name,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        child: const Text(
                                          'Ignore',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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