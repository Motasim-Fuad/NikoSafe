// Path: View/user/MyProfile/AllConnectsView.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/MyProfile/my_profile_details_controller/connectController.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';

class AllConnectsView extends StatelessWidget {
  final controller = Get.put(ConnectsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF253038),
      appBar: AppBar(
        title: Text('All Connects', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF253038),
        leading: BackButton(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.refreshFriends(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: Colors.tealAccent),
          );
        }

        if (controller.connects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No friends yet',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.refreshFriends(),
          color: Colors.tealAccent,
          backgroundColor: Color(0xFF37424A),
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.connects.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (_, index) {
              final user = controller.connects[index];
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF37424A),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: user.profilePicture != null && user.profilePicture!.isNotEmpty
                          ? NetworkImage(user.imageUrl)
                          : AssetImage('assets/images/peopleProfile4.jpg') as ImageProvider,
                      backgroundColor: Colors.grey[800],
                    ),
                    SizedBox(height: 8),
                    Text(
                      user.name,
                      style: TextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${user.totalPosts} posts',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // ✅ Fixed: Pass the ConnectUser object, not currentUserId
                        IconButton(
                          onPressed: () {
                            Get.toNamed(
                              RouteName.chatDetailView,
                              arguments: user, // ✅ Pass entire user object
                            );
                          },
                          icon: Icon(Icons.chat_bubble_outline, color: Colors.tealAccent),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () => controller.removeConnect(index),
                          child: Text("Remove", style: TextStyle(color: Colors.red, fontSize: 12)),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}