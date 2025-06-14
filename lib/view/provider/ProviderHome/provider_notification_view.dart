import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/view/provider/ProviderHome/widgets/notification_card.dart';
import '../../../View_Model/Controller/provider/providerHomeController/notification_controller.dart';
import '../../../resource/compunents/customSearchBar.dart';

class ProviderNotificationBottomSheet extends StatelessWidget {
  const ProviderNotificationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    final searchController = TextEditingController();

    controller.loadNotifications();

    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            "Notification",
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            // ✅ Reusable Search Bar
            CustomSearchBar(
              controller: searchController,
              onChanged: controller.onSearchChanged,
              hintText: "Search notifications...",
            ),

            // ✅ Filtered Notifications
            Expanded(
              child: Obx(() => controller.filteredNotifications.isEmpty
                  ? Center(child: Text("No notifications found",style: TextStyle(color: AppColor.primaryTextColor),))
                  : ListView.builder(
                itemCount: controller.filteredNotifications.length,
                itemBuilder: (_, i) => NotificationCard(
                  notification: controller.filteredNotifications[i],
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
