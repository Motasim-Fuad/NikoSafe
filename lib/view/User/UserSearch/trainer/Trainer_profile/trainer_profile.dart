
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

import '../../../../../View_Model/toggle_tab_controller.dart';
import '../../../../../models/userSearch/trainer/trainer_model.dart';
import '../../../../../resource/compunents/toggle_tab_button.dart';
import 'AboutPage/trainer_about_view.dart';
import 'ReceptionPage/trainer_ReceptionView.dart';


class TrainerProfile extends StatelessWidget {
  final toggleController = Get.put(ToggleTabController());
  final TrainerModel trainer = Get.arguments;
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(trainer.imageUrl),
              ),
              const SizedBox(height: 16),
              Text(
                trainer.name,
                style:  TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: AppColor.primaryTextColor),
              ),
              Text(trainer.role,style: TextStyle(color: AppColor.primaryTextColor),),
              Text('Experience: ${trainer.experience}',style: TextStyle(color: AppColor.primaryTextColor),),
              Text('Rate: ${trainer.rate}',style: TextStyle(color: AppColor.primaryTextColor),),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RoundedToggleTab(
                  tabs: ['Reception', 'About'],
                  controller: toggleController,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  return toggleController.selectedIndex.value == 0
                      ? TrainerReceptionView()
                      : TrainerAboutView();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
