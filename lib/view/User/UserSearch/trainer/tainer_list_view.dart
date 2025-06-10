import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import '../../../../View_Model/Controller/user/userSearch/trainer/trainer_controller.dart';

import 'widgets/trainer_card.dart';

class TrainerView extends StatelessWidget {
  final TrainerController controller = Get.put(TrainerController());

  TrainerView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title:  Text("Trainer",style: TextStyle(color: AppColor.primaryTextColor),),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search by name or role",
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.search,color: Colors.white,),
                    filled: true,
                     fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: controller.searchTrainer,
                ),
              ),

              // Grid of Trainer Cards
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.trainerList.isEmpty) {
                    return const Center(child: Text("No trainers found."));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: controller.trainerList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final trainer = controller.trainerList[index];
                      return TrainerCard(trainer: trainer);
                    },
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
