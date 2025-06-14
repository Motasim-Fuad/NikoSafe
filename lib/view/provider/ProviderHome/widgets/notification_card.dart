import 'package:flutter/material.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

import '../../../../models/Provider/providerHomeModel/notification_model.dart';


class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.cardColor,
      child: ListTile(
        title: Text(notification.title, style:  TextStyle(fontWeight: FontWeight.bold,color: AppColor.primaryTextColor)),
        subtitle: Text(notification.message,style: TextStyle(color: AppColor.secondaryTextColor),),
        trailing: Text(notification.time, style:  TextStyle(fontSize: 12, color: Colors.grey)),
      ),
    );
  }
}
