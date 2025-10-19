// View_Model/Controller/user/MyProfile/my_profile_details_controller/my_profile_detailsController.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userProfile/user_my_profile_details.dart';
import 'package:nikosafe/models/User/myProfileModel/my_profile_details_model.dart';

class MyProfileDetailsController extends GetxController {
  final profile = Rxn<MyProfileDetailsModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final _repository = MyProfileRepository();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('🔄 Loading profile...');
      final data = await _repository.getProfileData();
      print('✅ Profile data received: ${data['email']}');

      profile.value = MyProfileDetailsModel.fromJson(data);
      print('✅ Profile loaded successfully');

    } catch (e) {
      errorMessage.value = 'Failed to load profile: $e';
      print('❌ Error loading profile: $e');

      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }
}