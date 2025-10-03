import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userHome/post/post_type_controller.dart';
import 'package:nikosafe/View_Model/Controller/userEmargencyContuctContrller/emergency_contact_controller.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import '../../../../View_Model/Controller/user/userHome/feedController.dart';


Widget topBar() {
  final emergencyController = Get.put(EmergencyContactController());
  final postTypeController = Get.put(PostTypeController());

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(ImageAssets.userHome_userProfile),
          radius: 20,
        ),
        SizedBox(width: 10),

        // Simple PopupMenuButton without complex reactive widgets
        PopupMenuButton<String>(
          color: AppColor.topLinear,
          onSelected: (value) {
            // Handle navigation based on API response
            if (value == 'normal') {
              Get.toNamed(RouteName.userCreatePostView);
            } else if (value == 'poll') {
              Get.toNamed(RouteName.createPollView);
            } else if (value == 'checkin') {
              Get.toNamed(RouteName.userCheckInView);
            } else if (value == 'create_post') {
              Get.toNamed(RouteName.userCreatePostView);
            } else if (value == 'create_poll') {
              Get.toNamed(RouteName.createPollView);
            } else if (value == 'Check_In') {
              Get.toNamed(RouteName.userCheckInView);
            }
          },
          itemBuilder: (context) {
            List<PopupMenuEntry<String>> menuItems = [];

            // Check if we have post types from API
            if (postTypeController.postTypes.isNotEmpty) {
              for (int i = 0; i < postTypeController.postTypes.length; i++) {
                final postType = postTypeController.postTypes[i];
                menuItems.add(
                  PopupMenuItem<String>(
                    value: postType.slug,
                    child: Text(postType.name, style: TextStyle(color: Colors.white)),
                  ),
                );

                // Add divider between items (except last one)
                if (i < postTypeController.postTypes.length - 1) {
                  menuItems.add(const PopupMenuDivider());
                }
              }
            } else {
              // Show default items if no API data
              menuItems.addAll([
                PopupMenuItem<String>(
                  value: 'create_post',
                  child: Text('Create Post', style: TextStyle(color: Colors.white)),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'create_poll',
                  child: Text('Create Poll', style: TextStyle(color: Colors.white)),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'Check_In',
                  child: Text('Check In', style: TextStyle(color: Colors.white)),
                ),
              ]);
            }

            return menuItems;
          },
          child: CircleAvatar(
            backgroundColor: AppColor.iconColor,
            maxRadius: 23,
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),

        Spacer(),

        GestureDetector(
          onTap: () {
            emergencyController.sendSOSAlert();
          },
          child: CircleAvatar(
            backgroundColor: Colors.red,
            maxRadius: 23,
            child: Text(
              "Alert",
              style: TextStyle(
                color: AppColor.primaryTextColor,
                fontSize: 13,
              ),
            ),
          ),
        ),

        SizedBox(width: 16),

        GestureDetector(
          onTap: () {
            Get.toNamed(RouteName.chatListView);
          },
          child: CircleAvatar(
            backgroundColor: AppColor.iconColor,
            maxRadius: 20,
            child: SvgPicture.asset(ImageAssets.userHome_chat),
          ),
        ),

        SizedBox(width: 16),

        GestureDetector(
          onTap: () {
            Get.toNamed(RouteName.userNotificationView);
          },
          child: CircleAvatar(
            backgroundColor: AppColor.iconColor,
            maxRadius: 20,
            child: SvgPicture.asset(ImageAssets.userHome_notification),
          ),
        ),
      ],
    ),
  );
}

Widget tabBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      tabItem('Feed', true),
      SizedBox(width: 12),
      tabItem('Connect', false),
    ],
  );
}

Widget tabItem(String text, bool isSelected) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    decoration: BoxDecoration(
      color: isSelected ? Color(0xFF1EBEA5) : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(text, style: TextStyle(color: Colors.white)),
  );
}

Widget healthCard(FeedController controller) {
  return Container(
    margin: EdgeInsets.all(12),
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColor.iconColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Text('👋', style: TextStyle(fontSize: 20)),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            "Your Health Insight\nYou've been staying below 0.05% BAC most nights. Great job moderating!",
            style: TextStyle(color: Colors.white),
          ),
        ),
        IconButton(
          onPressed: () {
            controller.showHealthCard.value = false;
          },
          icon: Icon(Icons.close, color: Colors.white),
        ),
      ],
    ),
  );
}
