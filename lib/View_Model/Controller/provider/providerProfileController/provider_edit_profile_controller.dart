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
  final aboutController = TextEditingController(text: 'I am a professional plumber with hands-on experience in fixing and installing water systems.I take pride in delivering quality service with honesty and efficiency From leaks to full piping systems, I’m here to help—no job is too small or big.');
  final cirtificationsController = TextEditingController(text: 'I am a certified plumber with training in residential and commercial plumbing systems.I hold certifications in pipefitting, water heater installation, and safety compliance.My credentials ensure reliable, code-compliant work every time.');
  final expriencesController = TextEditingController(text: '7 years');



  final fullNameFocus = FocusNode();
  final jobTitleFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();
  final payRateFocus = FocusNode();
  final locationFocus = FocusNode();
  final radiusFocus = FocusNode();
  final aboutFocus = FocusNode();
  final certificationsFocus = FocusNode();
  final experienceFocus = FocusNode();

  void saveProfile() {
    // Your save logic here
Utils.successSnackBar('Success', 'Profile Saved');
  }



  @override
  void onInit() {
    super.onInit();

    fullNameFocus.addListener(() {
      if (fullNameFocus.hasFocus) debugPrint("✅ Full Name Focused");
    });

    jobTitleFocus.addListener(() {
      if (jobTitleFocus.hasFocus) debugPrint("✅ Job Title Focused");
    });

    emailFocus.addListener(() {
      if (emailFocus.hasFocus) debugPrint("✅ Email Focused");
    });

    phoneFocus.addListener(() {
      if (phoneFocus.hasFocus) debugPrint("✅ Phone Focused");
    });

    payRateFocus.addListener(() {
      if (payRateFocus.hasFocus) debugPrint("✅ Pay Rate Focused");
    });

    locationFocus.addListener(() {
      if (locationFocus.hasFocus) debugPrint("✅ Location Focused");
    });

    radiusFocus.addListener(() {
      if (radiusFocus.hasFocus) debugPrint("✅ Radius Focused");
    });

    aboutFocus.addListener(() {
      if (aboutFocus.hasFocus) debugPrint("✅ About Me Focused");
    });

    certificationsFocus.addListener(() {
      if (certificationsFocus.hasFocus) debugPrint("✅ Certifications Focused");
    });

    experienceFocus.addListener(() {
      if (experienceFocus.hasFocus) debugPrint("✅ Experience Focused");
    });
  }



  @override
  void onClose() {
    fullNameFocus.dispose();
    jobTitleFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    payRateFocus.dispose();
    locationFocus.dispose();
    radiusFocus.dispose();
    aboutFocus.dispose();
    certificationsFocus.dispose();
    experienceFocus.dispose();

    super.onClose();
  }
}
