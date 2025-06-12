import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userHome/userNotification/user_notification_controller.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/view/User/userNotification/widgets/userNotificationCardWidgets.dart';

import '../../../resource/compunents/customBackButton.dart';


class UserNotificationView extends StatelessWidget {
  const UserNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserNotificationController());

    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Notification", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
                children: [
      // 🔍 Search TextField
                  TextField(
                    onChanged: controller.onSearchChanged,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search notifications...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: AppColor.iconColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

      // 🔔 Notification list
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.filteredNotifications.length,
                      itemBuilder: (context, index) {
                        return UserNotificationCard(
                          model: controller.filteredNotifications[index],
                        );
                      },
                    ),
                  ),
                ],
              );



          }),
        ),
      ),
    );
  }
}

