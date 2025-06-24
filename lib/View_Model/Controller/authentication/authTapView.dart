import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

class AuthTabController extends GetxController {
  final selectedTab = 0.obs; // 0: Login, 1: Signup
  final selectedRole = 'user'.obs; // 'user', 'service_provider', 'vendor'
  final agreeTerms = false.obs;
  final pickedImage = Rxn<File>();

  void switchToLogin() {
    selectedTab.value = 0;
  }

  void switchToSignup() {
    selectedTab.value = 1;
  }

  void setRole(String role) {
    selectedRole.value = role;
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        pickedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }
}