import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/models/Provider/providerHomeModel/task_model.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

class ProviderTaskDetailsView extends StatelessWidget {
  const ProviderTaskDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final task = Get.arguments;

    if (task == null || task is! TaskModel) {
      return Scaffold(
        body: Center(
          child: Text("No task data provided"),
        ),
      );
    }

    final TaskModel taskModel = task;
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            "Task Details",
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: CustomBackButton(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Profile Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      task.clientImage,
                      height: width * 0.25,
                      width: width * 0.25,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Client: ${task.client}",
                            style: TextStyle(color: AppColor.primaryTextColor)),
                        Text("Email: ${task.email}",
                            style: TextStyle(color: AppColor.primaryTextColor)),
                        Text("Phone: ${task.phone}",
                            style: TextStyle(color: AppColor.primaryTextColor)),
                        Text("Location: ${task.location}",
                            style: TextStyle(color: AppColor.primaryTextColor)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Task Title
              Text("Task Title",
                  style: TextStyle(
                      color: AppColor.primaryTextColor,
                      fontWeight: FontWeight.bold)),
              Text(task.service, style: TextStyle(color: Colors.green)),

              const SizedBox(height: 10),

              /// Task Description
              Text("Task Description",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryTextColor)),
              const SizedBox(height: 5),
              Text(task.description, style: TextStyle(color: Colors.greenAccent)),

              const SizedBox(height: 10),

              /// Time Info
              Row(
                children: [
                  Text("Estimated Time: ",
                      style: TextStyle(
                          color: AppColor.primaryTextColor,
                          fontWeight: FontWeight.bold)),
                  const Text("3 hours", style: TextStyle(color: Colors.green))
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text("Preferred Time: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryTextColor)),
                  Text(task.time, style: TextStyle(color: AppColor.primaryTextColor)),
                ],
              ),

              const SizedBox(height: 20),

              /// Project Images
              Text("Photos of the project",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryTextColor)),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: task.projectImages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      task.projectImages[index],
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Buttons
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {}, child: const Text("Accept Offer"))),
                  const SizedBox(width: 10),
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () {}, child: const Text("Reject Offer"))),
                ],
              ),
              const SizedBox(height: 10),
              RoundButton(width: double.infinity,title: "Send Quote", onPress: (){
                Get.toNamed(RouteName.providerSendQuoteView);
              })
            ],
          ),
        ),
      ),
    );
  }
}
