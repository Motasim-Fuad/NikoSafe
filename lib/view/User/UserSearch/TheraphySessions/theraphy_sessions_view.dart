
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';

import '../../../../../View_Model/toggle_tab_controller.dart';
import '../../../../../models/userSearch/trainer/trainer_model.dart';
import '../../../../../resource/compunents/toggle_tab_button.dart';


class TheraphySessionsView extends StatelessWidget {
  final toggleController = Get.put(ToggleTabController());

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


              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RoundedToggleTab(
                  tabs: ['Reception', 'About'],
                  controller: toggleController,
                ),
              ),
              const SizedBox(height: 20),
              // Expanded(
              //   child: Obx(() {
              //     return toggleController.selectedIndex.value == 0
              //         ? TrainerReceptionView()
              //         : TrainerAboutView();
              //   }),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
