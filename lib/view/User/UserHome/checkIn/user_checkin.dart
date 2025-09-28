import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nikosafe/View_Model/Controller/user/userHome/post/checkIn/user_check_in_controller.dart' show UserCheckInController;
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';

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

          // When not yet checked-in
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

          // After successful check-in - Show map and post form
          final location = controller.location.value!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Location Info
                Text(
                  "You're checked in at:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryTextColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  location.address,
                  style: TextStyle(color: AppColor.primaryTextColor),
                ),
                const SizedBox(height: 5),
                Text(
                  "Lat: ${location.latitude.toStringAsFixed(6)}",
                  style: TextStyle(color: AppColor.primaryTextColor, fontSize: 12),
                ),
                Text(
                  "Lng: ${location.longitude.toStringAsFixed(6)}",
                  style: TextStyle(color: AppColor.primaryTextColor, fontSize: 12),
                ),
                const SizedBox(height: 20),

                // Google Map Container
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(location.latitude, location.longitude),
                        zoom: 16.0, // Default zoom level
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('checkin_location'),
                          position: LatLng(location.latitude, location.longitude),
                          infoWindow: InfoWindow(
                            title: 'Check-in Location',
                            snippet: location.address,
                          ),
                        ),
                      },
                      onMapCreated: (GoogleMapController mapController) {
                        // Map created
                      },
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Open in Google Maps Button
                RoundButton(
                  title: "Open in Google Maps",
                  onPress: controller.openInGoogleMaps,
                ),
                const SizedBox(height: 30),

                // Post Form
                Text(
                  "Create Post",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryTextColor,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 15),

                // Title Field
                TextFormField(
                  controller: controller.titleController,
                  style: TextStyle(color: AppColor.primaryTextColor),
                  decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(color: AppColor.primaryTextColor.withOpacity(0.7)),
                    hintText: "e.g., At the gym!",
                    hintStyle: TextStyle(color: AppColor.primaryTextColor.withOpacity(0.5)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.primaryTextColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.primaryTextColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Text Field
                TextFormField(
                  controller: controller.textController,
                  maxLines: 3,
                  style: TextStyle(color: AppColor.primaryTextColor),
                  decoration: InputDecoration(
                    labelText: "Post Text",
                    labelStyle: TextStyle(color: AppColor.primaryTextColor.withOpacity(0.7)),
                    hintText: "e.g., Time for morning workout",
                    hintStyle: TextStyle(color: AppColor.primaryTextColor.withOpacity(0.5)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.primaryTextColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.primaryTextColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Location Name Field
                TextFormField(
                  controller: controller.locationNameController,
                  style: TextStyle(color: AppColor.primaryTextColor),
                  decoration: InputDecoration(
                    labelText: "Location Name",
                    labelStyle: TextStyle(color: AppColor.primaryTextColor.withOpacity(0.7)),
                    hintText: "e.g., Gold's Gym",
                    hintStyle: TextStyle(color: AppColor.primaryTextColor.withOpacity(0.5)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.primaryTextColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColor.primaryTextColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Post Button
                Obx(() => RoundButton(
                  title: controller.isPostLoading.value ? "Creating..." : "Create Post",
                  onPress: controller.isPostLoading.value ? (){} : controller.createCheckingPost,
                )),
                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }
}