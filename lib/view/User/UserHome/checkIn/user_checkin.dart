// check_in/view/check_in_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';

import '../../../../View_Model/Controller/user/userHome/checkIn/user_check_in_controller.dart';


class UserCheckInView extends StatelessWidget {
  final UserCheckInController controller = Get.put(UserCheckInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Check In")),
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(controller.location.value!.address),
                const SizedBox(height: 10),
                Text("Lat: ${controller.location.value!.latitude}"),
                Text("Lng: ${controller.location.value!.longitude}"),


                SizedBox(height:10,),
                RoundButton(title: "open map", onPress: () {
                  controller.openInGoogleMaps();

                },)
              ]
            ],
          );
        }),
      ),
    );
  }
}
