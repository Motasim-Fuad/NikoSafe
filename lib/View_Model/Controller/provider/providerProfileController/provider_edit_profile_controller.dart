import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/Provider/providerProfileRepo/provider_profile_repo.dart';
import 'package:nikosafe/utils/utils.dart';

class ProviderEditProfileController extends GetxController {
  final _repo = ProviderProfileRepo();

  RxBool loading = false.obs;
  RxBool isAvailable = false.obs;

  Rx<File?> profileImage = Rx<File?>(null);
  RxString profileImageUrl = ''.obs;

  void setProfileImage(File file) => profileImage.value = file;

  final fullNameController = TextEditingController();
  final jobTitleController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final payRateController = TextEditingController();
  final locationController = TextEditingController();
  final radiusController = TextEditingController();
  final aboutController = TextEditingController();
  final cirtificationsController = TextEditingController();
  final expriencesController = TextEditingController();

  final availFromDateController = TextEditingController();
  final availToDateController = TextEditingController();
  final availFromTimeController = TextEditingController();
  final availToTimeController = TextEditingController();

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

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    loading.value = true;
    try {
      final response = await _repo.fetchProfile();

      if (response != null && response['success'] == true) {
        final data = response['data'];

        // Basic fields
        fullNameController.text = data['full_name'] ?? '';
        jobTitleController.text = data['job_title'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phone_number'] ?? '';
        locationController.text = data['location'] ?? '';
        radiusController.text = '${data['service_radius'] ?? 10}';
        aboutController.text = data['about_me'] ?? '';
        expriencesController.text = '${data['years_of_experience'] ?? 0}';
        payRateController.text = data['desired_pay_rate']?.toString() ?? '';

        // ✅ Profile Image URL
        if (data['profile_picture'] != null && data['profile_picture'].toString().isNotEmpty) {
          profileImageUrl.value = data['profile_picture'];
        }

        // ✅ Handle certificates as List or String
        if (data['certificates'] is List) {
          cirtificationsController.text = (data['certificates'] as List).join(', ');
        } else {
          cirtificationsController.text = data['certificates']?.toString() ?? '';
        }

        // ✅ Availability Data - Show in Form
        isAvailable.value = data['is_available'] ?? false;
        availFromDateController.text = data['available_from_date'] ?? '';
        availToDateController.text = data['available_to_date'] ?? '';
        availFromTimeController.text = data['available_from_time'] ?? '';
        availToTimeController.text = data['available_to_time'] ?? '';

        print("✅ Profile loaded successfully");
        print("✅ Availability: ${isAvailable.value}");
        print("✅ From Date: ${availFromDateController.text}");
        print("✅ To Date: ${availToDateController.text}");
        print("✅ From Time: ${availFromTimeController.text}");
        print("✅ To Time: ${availToTimeController.text}");
      }

    } catch (e) {
      print("❌ Error loading profile: $e");
      Utils.errorSnackBar('Error', 'Failed to load profile');
    } finally {
      loading.value = false;
    }
  }

  Future<void> saveProfile() async {
    loading.value = true;
    try {
      // ✅ Convert certificates string to array
      List<String> certificatesList = [];
      if (cirtificationsController.text.trim().isNotEmpty) {
        certificatesList = cirtificationsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }

      final data = {
        "full_name": fullNameController.text.trim(),
        "designation": jobTitleController.text.trim(),
        "phone_number": phoneController.text.trim(),
        "job_title": jobTitleController.text.trim(),
        "location": locationController.text.trim(),
        "service_radius": int.tryParse(radiusController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 10,
        "about_me": aboutController.text.trim(),
        "skills": [],
        "certificates": certificatesList,
        "years_of_experience": int.tryParse(expriencesController.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
        "desired_pay_rate": payRateController.text.replaceAll(RegExp(r'[^0-9.]'), ''),

        // ✅ Availability fields - Send to Backend
        "is_available": isAvailable.value,
        "available_from_date": availFromDateController.text.trim(),
        "available_to_date": availToDateController.text.trim(),
        "available_from_time": availFromTimeController.text.trim(),
        "available_to_time": availToTimeController.text.trim(),
      };

      print("📤 Updating profile with data: $data");

      final response = await _repo.updateProfile(data, profileImage.value);

      print("📥 Update response: $response");

      if (response != null && response['success'] == true) {
        Utils.successSnackBar('Success', response['message'] ?? 'Profile updated successfully');
        profileImage.value = null;
        await fetchProfileData(); // Refresh to show updated data
      } else {
        Utils.errorSnackBar('Error', response?['message'] ?? 'Update failed');
      }

    } catch (e) {
      print("❌ Save profile error: $e");
      Utils.errorSnackBar('Error', 'Failed to save profile');
    } finally {
      loading.value = false;
    }
  }

  void toggleAvailability(bool value) {
    isAvailable.value = value;
    print("✅ Availability toggled: $value");
  }

  Future<void> pickDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      print("✅ Date picked: ${controller.text}");
    }
  }

  Future<void> pickTime(TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.text = picked.format(Get.context!);
      print("✅ Time picked: ${controller.text}");
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    jobTitleController.dispose();
    emailController.dispose();
    phoneController.dispose();
    payRateController.dispose();
    locationController.dispose();
    radiusController.dispose();
    aboutController.dispose();
    cirtificationsController.dispose();
    expriencesController.dispose();
    availFromDateController.dispose();
    availToDateController.dispose();
    availFromTimeController.dispose();
    availToTimeController.dispose();

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