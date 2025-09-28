import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:nikosafe/View_Model/Controller/user/userHome/post/checkIn/user_check_in_controller.dart' show UserCheckInController;
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/utils/utils.dart';


class UserCheckInView extends StatelessWidget {
  final UserCheckInController controller = Get.put(UserCheckInController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Check In", style: TextStyle(color: AppColor.primaryTextColor)),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          backgroundColor: Colors.transparent,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // 👉 When not yet checked-in
          if (controller.location.value == null) {
            return Center(
              child: GestureDetector(
                onTap: () {
                  controller.checkIn();
                },
                child: Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    boxShape: NeumorphicBoxShape.circle(),
                    depth: -90,
                    intensity: 0.8,
                    shadowDarkColor: Colors.grey,
                    lightSource: LightSource.topLeft,
                    color: Colors.white,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    child: const FittedBox(
                      child: Text(
                        "Check In",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          // 👉 After successful check-in
          final location = controller.location.value!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "You're checked in at:",
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.primaryTextColor),
                ),
                const SizedBox(height: 10),
                Text(location.address, style: TextStyle(color: AppColor.primaryTextColor)),
                const SizedBox(height: 10),
                Text("Lat: ${location.latitude}", style: TextStyle(color: AppColor.primaryTextColor)),
                Text("Lng: ${location.longitude}", style: TextStyle(color: AppColor.primaryTextColor)),
                const SizedBox(height: 20),
                RoundButton(
                  title: "Open Map",
                  onPress: controller.openInGoogleMaps,
                ),
                const SizedBox(height: 10),
                RoundButton(
                  title: "Post",
                  onPress: () {
                    Utils.successSnackBar("Check In", "Post successfully");
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
