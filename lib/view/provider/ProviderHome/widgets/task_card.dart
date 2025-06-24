import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import '../../../../models/Provider/providerHomeModel/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(RouteName.providerTaskDetailView,arguments: task);
      },
      child: Card(
        color: AppColor.cardColor,
        margin: const EdgeInsets.symmetric(vertical: 6),

        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(task.service, style:  TextStyle(fontWeight: FontWeight.bold,color: AppColor.primaryTextColor)),
            Text("Client: ${task.client}",style: TextStyle(color: AppColor.primaryTextColor),),
            Row(children: [
               Icon(Icons.calendar_today, size: 14,color: AppColor.primaryTextColor,),
               SizedBox(width: 4),
              Text(task.date,style: TextStyle(color: AppColor.primaryTextColor),),
               SizedBox(width: 10),
               Icon(Icons.access_time, size: 14,color: AppColor.primaryTextColor),
               SizedBox(width: 4),
              Text(task.time,style: TextStyle(color: AppColor.primaryTextColor),),
            ]),
            Row(children: [
               Icon(Icons.location_on, size: 14,color: AppColor.primaryTextColor),
               SizedBox(width: 4),
              Text(task.location,style: TextStyle(color: AppColor.primaryTextColor),),
            ]),
          ]),
        ),
      ),
    );
  }
}
