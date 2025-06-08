// check_in/view/check_in_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/utils/utils.dart';

import '../../../../View_Model/Controller/user/userHome/checkIn/user_check_in_controller.dart';


class UserCheckInView extends StatelessWidget {
  final UserCheckInController controller = Get.put(UserCheckInController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: Text("Check In",style: TextStyle(color: AppColor.primaryTextColor),),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.isNotEmpty) {
              print(controller.errorMessage.value);
              return Center(
                child: Text(controller.errorMessage.value),

              );

            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: controller.checkIn,
                  icon: Icon(Icons.location_on),
                  label: Text("Check In"),
                ),
                const SizedBox(height: 20),
                if (controller.location.value != null) ...[
                  Text(
                    "You're checked in at:",
                    style: TextStyle(fontWeight: FontWeight.bold,color: AppColor.primaryTextColor),
                  ),
                  const SizedBox(height: 10),
                  Text(controller.location.value!.address,style: TextStyle(color: AppColor.primaryTextColor)),
                  const SizedBox(height: 10),
                  Text("Lat: ${controller.location.value!.latitude}",style: TextStyle(color: AppColor.primaryTextColor)),
                  Text("Lng: ${controller.location.value!.longitude}",style: TextStyle(color: AppColor.primaryTextColor)),


                  SizedBox(height:10,),
                  RoundButton(title: "open map", onPress: () {
                    controller.openInGoogleMaps();

                  },),

                  SizedBox(height: 10,),
                  RoundButton(title: "Post", onPress: () {
                    Utils.snackBar("Check In", "Post successfully");
                  },)
                ]
              ],
            );
          }),
        ),
      ),
    );
  }
}
