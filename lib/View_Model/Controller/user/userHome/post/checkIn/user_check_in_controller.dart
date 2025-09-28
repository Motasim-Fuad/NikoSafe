import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nikosafe/Repositry/checkInRepo/checkInRepository.dart';
import 'package:nikosafe/models/chackin/checkInModel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nikosafe/utils/utils.dart';

class UserCheckInController extends GetxController {
  final UserCheckInRepository _checkInRepository = UserCheckInRepository();
  // final PostRepository _postRepository = PostRepository();

  Rx<UserCheckInModel?> location = Rx<UserCheckInModel?>(null);
  RxBool isLoading = false.obs;
  RxBool isPostLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Post form fields
  final titleController = TextEditingController();
  final textController = TextEditingController();
  final locationNameController = TextEditingController();
  final RxInt privacy = 2.obs; // Default privacy level
  final RxInt postType = 1.obs; // Default post type

  @override
  void onClose() {
    titleController.dispose();
    textController.dispose();
    locationNameController.dispose();
    super.onClose();
  }

  Future<void> checkIn() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final position = await _checkInRepository.getCurrentPosition();
      final address = await _checkInRepository.getAddressFromLatLng(position);
      location.value = UserCheckInModel(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void openInGoogleMaps() {
    final loc = location.value;
    if (loc == null) {
      Get.snackbar("Error", "No location found");
      return;
    }

    final latitude = loc.latitude;
    final longitude = loc.longitude;

    final Uri gmapUri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");

    launchUrl(gmapUri, mode: LaunchMode.externalApplication).catchError((e) {
      Get.snackbar("Failed", "Could not open Google Maps");
    });
  }

  Future<void> createCheckingPost() async {
    final loc = location.value;
    if (loc == null) {
      Get.snackbar("Error", "No location found");
      return;
    }

    // Validate required fields
    if (titleController.text.trim().isEmpty) {
      Get.snackbar("Error", "Title is required");
      return;
    }

    if (textController.text.trim().isEmpty) {
      Get.snackbar("Error", "Post text is required");
      return;
    }

    if (locationNameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Location name is required");
      return;
    }

    isPostLoading.value = true;

    try {
      final response = await _checkInRepository.createCheckInPost(
        title: titleController.text.trim(),
        text: textController.text.trim(),
        locationName: locationNameController.text.trim(),
        latitude: loc.latitude,
        longitude: loc.longitude,
        address: loc.address,
        privacy: privacy.value,
        postType: postType.value,
      );

      if (response['success'] == true) {
        Utils.successSnackBar("Success", "Post created successfully!");
        clearForm();
        // Optional: Navigate back or to posts list
        Get.back();
      } else {
        Utils.toastMessage(response['message'] ?? "Failed to create post");
      }
    } catch (e) {
      print("Create post error: $e");
      Utils.toastMessage("Failed to create post: ${e.toString()}");
    } finally {
      isPostLoading.value = false;
    }
  }

  void clearForm() {
    titleController.clear();
    textController.clear();
    locationNameController.clear();
    privacy.value = 2;
    postType.value = 1;
  }
}