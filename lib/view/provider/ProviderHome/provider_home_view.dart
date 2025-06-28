import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/view/provider/ProviderHome/widgets/earning_card.dart';
import '../../../View_Model/Controller/authentication/authentication_view_model.dart';
import '../../../View_Model/Controller/provider/providerHomeController/task_controller.dart';
import 'provider_notification_view.dart';
import 'widgets/task_card.dart';

class ProviderHomeView extends StatelessWidget {
  const ProviderHomeView({super.key});

  @override
  Widget build(BuildContext context) {

    final taskController = Get.put(TaskController());
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  CircleAvatar(
                    backgroundImage: AssetImage(ImageAssets.userHome_peopleProfile4),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      Get.toNamed(RouteName.chatListView);
                    },
                    child: CircleAvatar(
                      backgroundColor: AppColor.iconColor,
                      maxRadius: 20,
                      child:SvgPicture.asset(ImageAssets.userHome_chat),
                    ),
                  ),
                  SizedBox(width: 10,),
                  CircleAvatar(
                    backgroundColor: AppColor.iconColor,
                    child: IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.white),
                   onPressed: (){
                        Get.toNamed(RouteName.providerNotificationBottomSheet);
                   },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              EarningCard(),
              const SizedBox(height: 20),
              const Text("New Tasks", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() => ListView.builder(
                  itemCount: taskController.tasks.length,
                  itemBuilder: (_, index) => TaskCard(task: taskController.tasks[index]),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
