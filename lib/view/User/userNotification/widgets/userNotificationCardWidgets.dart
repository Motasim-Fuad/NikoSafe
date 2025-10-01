import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/models/Notification/userNotification_model.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/view/User/userNotification/QutationReviewview.dart';

class UserNotificationCard extends StatelessWidget {
  final UsernotificationModel model;

  const UserNotificationCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.iconColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(model.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ),
                Text(model.time,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 8),
            Text(model.message, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            if (model.tag != null)
              Text(
                "📍 ${model.tag}",
                style: const TextStyle(color: Colors.cyan, fontSize: 13),
              ),
            if (model.action1 != null ||
                model.action2 != null ||
                model.action3 != null)
              const SizedBox(height: 12),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (model.action1 != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleAction1,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        foregroundColor: const Color(0xff78bc4c),
                        backgroundColor: const Color(0xFF435C34),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(model.action1!, style: const TextStyle(fontSize: 14)),
                    ),
                  ),
                if (model.action2 != null) const SizedBox(width: 10),
                if (model.action2 != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        foregroundColor: const Color(0xffcd2929),
                        backgroundColor: const Color(0x4dcd2929),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(model.action2!, style: const TextStyle(fontSize: 14)),
                    ),
                  ),
                if (model.action3 != null) const SizedBox(width: 10),
                if (model.action3 != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        foregroundColor: AppColor.primaryTextColor,
                        backgroundColor: AppColor.iconColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(model.action3!, style: const TextStyle(fontSize: 14)),
                    ),
                  ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  void _handleAction1() {
    // Check if this is a quote notification with "Review Now" action
    if (model.action1 == "Review Now" &&
        model.serviceProvider != null &&
        model.quote != null) {
      Get.to(() => QuotationReviewView(
        serviceProvider: model.serviceProvider!,
        quote: model.quote!,
      ));
    } else {
      // Handle other action1 types
      print("Action1 pressed: ${model.action1}");
    }
  }
}