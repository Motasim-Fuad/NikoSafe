import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

import '../../../View_Model/Controller/user/userHome/connectController.dart';
import '../../../models/userHome/connect_provider_model.dart';
import '../../../models/userHome/connect_user_model.dart';
import '../../../resource/Colors/app_colors.dart';
import '../../../resource/compunents/RoundButton.dart';

class ProfileDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ConnectController controller = Get.put(ConnectController());


    final dynamic user = Get.arguments;
    if (user is! ConnectUser && user is! ConnectProvider) {
      return Center(child: Text("Invalid user data"));
    }


    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // AppBar Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomBackButton(),
                    const Text(
                      'Profile Details',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.more_horiz, color: Colors.white),
                  ],
                ),
              ),

              // Avatar, Name, Connect button
              const SizedBox(height: 12),
              CircleAvatar(
                backgroundImage: AssetImage(user.imageUrl),
                radius: 45,
              ),
              const SizedBox(height: 10),
              Text(
                user.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),

                RoundButton(
                  onPress: () => controller.sendFriendRequest(user.name),
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.4,
                  title: "Connect",
                ),

              const SizedBox(height: 16),

              // Posts and Connect count
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${user.postCount}",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  const Text("Posts", style: TextStyle(color: Colors.grey)),
                  const SizedBox(width: 20),
                  Text(
                    "${user.connectCount}",
                    style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  const Text("Connect", style: TextStyle(color: Colors.grey)),
                ],
              ),


              const SizedBox(height: 16),

              // Grid of images (dummy images used here)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    itemCount: user.postedImage.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final image = user.postedImage[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          image,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
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
