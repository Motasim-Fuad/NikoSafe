import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/view/provider/ProviderHome/widgets/earning_card.dart';
import '../../../View_Model/Controller/provider/providerHomeController/task_controller.dart';
import 'widgets/task_card.dart';

class ProviderHomeView extends StatelessWidget {
  const ProviderHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.put(TaskController());

    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),

              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(ImageAssets.userHome_peopleProfile4),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteName.providerChatListView);
                    },
                    child: CircleAvatar(
                      backgroundColor: AppColor.iconColor,
                      maxRadius: 20,
                      child: SvgPicture.asset(ImageAssets.userHome_chat),
                    ),
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: AppColor.iconColor,
                    child: IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {
                        Get.toNamed(RouteName.providerNotificationBottomSheet);
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              EarningCard(),
              const SizedBox(height: 20),

              // Title with Refresh Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "New Tasks",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.white),
                    onPressed: () => taskController.refreshTasks(),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Task List with Loading & Error Handling
              Expanded(
                child: Obx(() {
                  if (taskController.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (taskController.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 60),
                          SizedBox(height: 16),
                          Text(
                            'Failed to load tasks',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => taskController.refreshTasks(),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (taskController.tasks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined, color: Colors.white54, size: 80),
                          SizedBox(height: 16),
                          Text(
                            'No pending tasks',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'New booking requests will appear here',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => taskController.refreshTasks(),
                    child: ListView.builder(
                      itemCount: taskController.tasks.length,
                      itemBuilder: (_, index) => TaskCard(
                        task: taskController.tasks[index],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}