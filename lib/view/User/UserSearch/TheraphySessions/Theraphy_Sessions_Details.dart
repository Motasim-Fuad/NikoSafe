
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/models/userSearch/theraphy_session/theraphy_session_model.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

import '../../../../View_Model/toggle_tab_controller.dart';
import '../../../../resource/compunents/toggle_tab_button.dart';



class  TheraphySessionsDetailsView extends StatelessWidget {
  final toggleController = Get.put(ToggleTabController());
  final TheraphySessionModel theraphy = Get.arguments;
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text("Session Details",style: TextStyle(color: Colors.white),),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [

                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image:  DecorationImage(image: AssetImage(theraphy.imageUrl),fit: BoxFit.cover),
                  ),

                ),
                 Row(
                   children: [
                     Text(theraphy.name),
                     Text("\$${theraphy.price} per session"),
                   ],
                 ),

                Row(
                  children: [
                    Column(
                      children: [
                            Text(theraphy.weekend),
                        Text(theraphy.time),
                      ],
                    ),

                    Text(theraphy.isAvailable ? "Available" : "Not Available",),
                  ],
                ),

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
      ),
    );
  }
}
