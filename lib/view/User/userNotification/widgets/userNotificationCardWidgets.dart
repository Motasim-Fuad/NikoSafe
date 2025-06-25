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
            Wrap(
              spacing: 18,
              children: [
                if (model.action1 != null)
                  ElevatedButton(
                    onPressed: () {
                      _handleAction1();
                    },
                    child: Text(model.action1!),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xff78bc4c),
                        backgroundColor: const Color(0xFF435C34)),
                  ),
                if (model.action2 != null)
                  ElevatedButton(
                      onPressed: () {},
                      child: Text(model.action2!),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xffcd2929),
                        backgroundColor: Color(0x4dcd2929),)
                  ),

                if (model.action3 != null)
                  RoundButton(
                    buttonColor: AppColor.iconColor,
                      shadowColor: Colors.transparent,
                      height: 40,
                      width: double.infinity,
                      title: model.action3!,
                      onPress: (){

                      }),

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