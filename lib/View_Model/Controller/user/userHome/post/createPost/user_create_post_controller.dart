import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/userHome_repo/user_create_post_repo.dart' show UserPostRepository;
import 'package:nikosafe/models/userCreatePost/UserLocation/user_location_model.dart';

import 'package:nikosafe/models/userCreatePost/user_create_post_model.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/utils/utils.dart';


class UserCreatePostController extends GetxController {
  final UserPostRepository userPostRepository;

  UserCreatePostController({required this.userPostRepository});

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  final Rx<UserLocationModel?> selectedLocation = Rx<UserLocationModel?>(null);
  final RxList<String> photoUrls = <String>[].obs;
  final RxBool isPosting = false.obs;

  @override
  void onClose() {
    descriptionController.dispose();
    tagsController.dispose();
    super.onClose();
  }

  // Navigate to add location screen and receive result
  Future<void> navigateToAddLocation() async {
    final result = await Get.toNamed(RouteName.userAddLocationView);
    if (result != null && result is UserLocationModel) {
      selectedLocation.value = result;
    }
  }

  void addPhoto() {
    // Simulate adding a photo (e.g., from gallery/camera)
    // In a real app, this would involve image picker logic.
    // For now, just add a placeholder URL.
    final newPhotoUrl = 'https://placehold.co/100x100/png?text=Photo${photoUrls.length + 1}';
    photoUrls.add(newPhotoUrl);
   Utils.infoSnackBar('Photo Added',
       'A placeholder photo has been added.');
  }

  Future<void> createPost() async {
    if (descriptionController.text.trim().isEmpty) {
      Utils.errorSnackBar(
        'Error',
        'Description cannot be empty.',
      );
      return;
    }

    isPosting.value = true;
    try {
      final post = UserCreatePostModel(
        description: descriptionController.text.trim(),
        tags: tagsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        photoUrls: photoUrls.toList(),
        location: selectedLocation.value,
        status: 'Public', // Default status
      );

      final success = await userPostRepository.createPost(post);

      if (success) {
        Utils.successSnackBar(
          'Success',
          'Post created successfully!',

        );
        // Clear fields after successful post
        descriptionController.clear();
        tagsController.clear();
        selectedLocation.value = null;
        photoUrls.clear();
      } else {
        Utils.errorSnackBar(
          'Error',
          'Failed to create post. Please try again.',

        );
      }
    } catch (e) {
      print('Error creating post: $e');
      Utils.errorSnackBar(
        'Error',
        'An unexpected error occurred.',
      );
    } finally {
      isPosting.value = false;
    }
  }
}
