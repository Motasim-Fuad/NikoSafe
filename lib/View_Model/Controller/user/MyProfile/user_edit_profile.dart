// View_Model/Controller/user/MyProfile/user_edit_profile.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nikosafe/Repositry/user_repo/userProfile/edit_profile_repo.dart';
import 'package:nikosafe/models/User/myProfileModel/my_profile_edit_model.dart';

class UserEditProfileController extends GetxController {
  final _repository = EditUserProfileRepository();

  // Observable variables
  var imagePath = "".obs;
  var isLoading = false.obs;
  var isSaving = false.obs;

  // Store current profile data
  Rx<MyProfileEditModel?> userProfile = Rx<MyProfileEditModel?>(null);

  // Text controllers
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final sexController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();

  // Focus nodes
  final nameFocus = FocusNode();
  final mobileFocus = FocusNode();
  final ageFocus = FocusNode();
  final weightFocus = FocusNode();
  final sexFocus = FocusNode();
  final locationFocus = FocusNode();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  // Fetch user profile from API
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;

      final profile = await _repository.getUserProfile();
      userProfile.value = profile;

      // Populate controllers with existing data
      nameController.text = profile.firstName ?? '';
      lastNameController.text = profile.lastName ?? '';
      mobileController.text = profile.mobileNumber ?? '';
      ageController.text = profile.age?.toString() ?? '';
      weightController.text = profile.weight?.toString() ?? '';
      sexController.text = profile.sex ?? '';
      emailController.text = profile.email ?? '';

      // Set profile image if exists
      if (profile.profilePicture != null && profile.profilePicture!.isNotEmpty) {
        // Store the URL for display (you'll need to handle network images in the view)
        imagePath.value = profile.profilePicture!;
      }

    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load profile: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Pick image from gallery
  void pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (picked != null) {
      imagePath.value = picked.path;
    }
  }

  // Get image file
  File? getImageFile() {
    if (imagePath.value.isNotEmpty && !imagePath.value.startsWith('http')) {
      return File(imagePath.value);
    }
    return null;
  }

  // Validate inputs
  bool validateInputs() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please enter your first name",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (mobileController.text.trim().isNotEmpty) {
      // Basic mobile validation (adjust regex as needed)
      final mobileRegex = RegExp(r'^\+?[\d\s-]{10,}$');
      if (!mobileRegex.hasMatch(mobileController.text.trim())) {
        Get.snackbar(
          "Validation Error",
          "Please enter a valid mobile number",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }

    if (ageController.text.trim().isNotEmpty) {
      final age = int.tryParse(ageController.text.trim());
      if (age == null || age < 1 || age > 150) {
        Get.snackbar(
          "Validation Error",
          "Please enter a valid age",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }

    if (weightController.text.trim().isNotEmpty) {
      final weight = int.tryParse(weightController.text.trim());
      if (weight == null || weight < 1 || weight > 500) {
        Get.snackbar(
          "Validation Error",
          "Please enter a valid weight",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }

    return true;
  }

  // Save profile to API
  Future<void> saveProfile() async {
    if (!validateInputs()) return;

    try {
      isSaving.value = true;

      // Prepare data
      Map<String, dynamic> data = {};

      if (nameController.text.trim().isNotEmpty) {
        data['first_name'] = nameController.text.trim();
      }

      if (lastNameController.text.trim().isNotEmpty) {
        data['last_name'] = lastNameController.text.trim();
      }

      if (mobileController.text.trim().isNotEmpty) {
        data['mobile_number'] = mobileController.text.trim();
      }

      if (ageController.text.trim().isNotEmpty) {
        data['age'] = int.parse(ageController.text.trim());
      }

      if (weightController.text.trim().isNotEmpty) {
        data['weight'] = int.parse(weightController.text.trim());
      }

      if (sexController.text.trim().isNotEmpty) {
        data['sex'] = sexController.text.trim().toLowerCase();
      }

      // Get image file if new image was selected
      File? imageFile = getImageFile();

      // Call repository to update profile
      final updatedProfile = await _repository.updateUserProfile(
        data: data,
        profileImage: imageFile,
      );

      // Update local profile data
      userProfile.value = updatedProfile;

      Get.snackbar(
        "Success",
        "Profile updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate back after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        Get.back();
      });

    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update profile: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    ageController.dispose();
    weightController.dispose();
    sexController.dispose();
    emailController.dispose();
    locationController.dispose();

    nameFocus.dispose();
    mobileFocus.dispose();
    ageFocus.dispose();
    weightFocus.dispose();
    sexFocus.dispose();
    locationFocus.dispose();

    super.onClose();
  }
}