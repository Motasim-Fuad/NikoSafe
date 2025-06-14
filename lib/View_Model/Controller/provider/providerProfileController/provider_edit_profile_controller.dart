import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/utils/utils.dart';

class ProfileData {
  bool isAvailable = true;
}

class ProviderEditProfileController extends GetxController {
  RxBool loading = false.obs;
  Rx<ProfileData> profile = ProfileData().obs;

  // Image upload
  Rx<File?> profileImage = Rx<File?>(null);
  void setProfileImage(File file) => profileImage.value = file;

  // Availability
  final availFromDateController = TextEditingController(text: '2025-06-14');
  final availToDateController = TextEditingController(text: '2025-07-14');
  final availFromTimeController = TextEditingController(text: '09:00 AM');
  final availToTimeController = TextEditingController(text: '05:00 PM');

  void toggleAvailability(bool value) {
    profile.update((val) {
      val?.isAvailable = value;
    });
  }

  Future<void> pickDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = "${picked.year}-${picked.month}-${picked.day}";
    }
  }

  Future<void> pickTime(TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.text = picked.format(Get.context!);
    }
  }

  // Profile Fields
  final fullNameController = TextEditingController(text: 'John Doe');
  final jobTitleController = TextEditingController(text: 'Plumber');
  final emailController = TextEditingController(text: 'john@example.com');
  final phoneController = TextEditingController(text: '+1234567890');
  final payRateController = TextEditingController(text: '\$22 per hour');
  final locationController = TextEditingController(text: 'Downtown LA');
  final radiusController = TextEditingController(text: 'Up to 10 km');

  void saveProfile() {
    // Your save logic here
Utils.snackBar('Success', 'Profile Saved');
  }
}
