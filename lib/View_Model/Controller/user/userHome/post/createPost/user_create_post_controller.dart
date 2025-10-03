import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nikosafe/Repositry/user_repo/home_repositry/home_repositry.dart';
import 'package:nikosafe/Repositry/user_repo/userHome_repo/user_create_post_repo.dart';
import 'package:nikosafe/models/User/userCreatePost/UserLocation/user_location_model.dart';
import 'package:nikosafe/models/User/userCreatePost/user_create_post_model.dart';
import 'package:nikosafe/models/User/userHome/postType_model.dart';
import 'package:nikosafe/models/User/userHome/privacy_options_model.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/utils/utils.dart';

class UserCreatePostController extends GetxController {
  final UserPostRepository userPostRepository;
  final HomeRepositry homeRepository;

  UserCreatePostController({
    required this.userPostRepository,
    required this.homeRepository,
  });

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  final Rx<UserLocationModel?> selectedLocation = Rx<UserLocationModel?>(null);
  final RxList<File> selectedImages = <File>[].obs;
  final RxBool isPosting = false.obs;
  final RxBool isLoadingPrivacy = false.obs;
  final RxBool isLoadingPostTypes = false.obs;

  // Privacy options
  final RxList<PrivacyOption> privacyOptions = <PrivacyOption>[].obs;
  final Rx<PrivacyOption?> selectedPrivacyOption = Rx<PrivacyOption?>(null);

  // Post types
  final RxList<PostType> postTypes = <PostType>[].obs;
  final Rx<PostType?> selectedPostType = Rx<PostType?>(null);

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  @override
  void onClose() {
    descriptionController.dispose();
    titleController.dispose();
    super.onClose();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadPrivacyOptions(),
      _loadPostTypes(),
    ]);
  }

  Future<void> _loadPrivacyOptions() async {
    try {
      isLoadingPrivacy.value = true;
      final response = await homeRepository.getPrivacyOptions();
      privacyOptions.assignAll(response.data);

      // Set default privacy option to first one (usually Public)
      if (privacyOptions.isNotEmpty) {
        selectedPrivacyOption.value = privacyOptions.first;
      }
    } catch (e) {
      Utils.errorSnackBar('Error', 'Failed to load privacy options');
      print('Error loading privacy options: $e');
    } finally {
      isLoadingPrivacy.value = false;
    }
  }

  Future<void> _loadPostTypes() async {
    try {
      isLoadingPostTypes.value = true;
      final response = await homeRepository.getPostTypes();
      postTypes.assignAll(response.data);

      // Set default post type to first one
      if (postTypes.isNotEmpty) {
        selectedPostType.value = postTypes.first;
      }
    } catch (e) {
      Utils.errorSnackBar('Error', 'Failed to load post types');
      print('Error loading post types: $e');
    } finally {
      isLoadingPostTypes.value = false;
    }
  }

  Future<void> navigateToAddLocation() async {
    final result = await Get.toNamed(RouteName.userAddLocationView);
    if (result != null && result is UserLocationModel) {
      selectedLocation.value = result;
    }
  }

  Future<void> addPhoto() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();

      if (images.isNotEmpty) {
        // Limit to 4 images total
        int remainingSlots = 4 - selectedImages.length;
        int imagesToAdd = images.length > remainingSlots ? remainingSlots : images.length;

        for (int i = 0; i < imagesToAdd; i++) {
          selectedImages.add(File(images[i].path));
        }

        Utils.successSnackBar(
            'Images Added',
            '$imagesToAdd image(s) added successfully'
        );

        if (images.length > remainingSlots) {
          Utils.infoSnackBar(
              'Limit Reached',
              'Maximum 4 images allowed. Only first $imagesToAdd images were added.'
          );
        }
      }
    } catch (e) {
      Utils.errorSnackBar('Error', 'Failed to pick images');
      print('Error picking images: $e');
    }
  }

  Future<void> addSinglePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null && selectedImages.length < 4) {
        selectedImages.add(File(image.path));
        Utils.successSnackBar('Image Added', 'Image added successfully');
      } else if (selectedImages.length >= 4) {
        Utils.infoSnackBar('Limit Reached', 'Maximum 4 images allowed');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', 'Failed to pick image');
      print('Error picking image: $e');
    }
  }

  Future<void> takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null && selectedImages.length < 4) {
        selectedImages.add(File(image.path));
        Utils.successSnackBar('Photo Taken', 'Photo added successfully');
      } else if (selectedImages.length >= 4) {
        Utils.infoSnackBar('Limit Reached', 'Maximum 4 images allowed');
      }
    } catch (e) {
      Utils.errorSnackBar('Error', 'Failed to take photo');
      print('Error taking photo: $e');
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
      Utils.infoSnackBar('Image Removed', 'Image removed successfully');
    }
  }

  Future<void> createPost() async {
    if (descriptionController.text.trim().isEmpty) {
      Utils.errorSnackBar('Error', 'Description cannot be empty.');
      return;
    }

    if (titleController.text.trim().isEmpty) {
      Utils.errorSnackBar('Error', 'Description cannot be empty.');
      return;
    }

    isPosting.value = true;
    try {
      final post = UserCreatePostModel(
        postType: selectedPostType.value?.id.toString(),
        title: titleController.text.trim(), // You can add title field if needed
        description: descriptionController.text.trim(),
        photoUrls: [], // Not needed for API call
        location: selectedLocation.value,
        status: selectedPrivacyOption.value?.name ?? 'Public',
      );

      final success = await userPostRepository.createPost(
        post,
        images: selectedImages.isNotEmpty ? selectedImages.toList() : null,
      );

      if (success) {
        Utils.successSnackBar('Success', 'Post created successfully!');
        _clearForm();
        Get.back(); // Navigate back to previous screen
      } else {
        Utils.errorSnackBar('Error', 'Failed to create post. Please try again.');
      }
    } catch (e) {
      print('Error creating post: $e');
      Utils.errorSnackBar('Error', 'An unexpected error occurred.');
    } finally {
      isPosting.value = false;
    }
  }

  void _clearForm() {
    descriptionController.clear();
    titleController.clear();
    selectedLocation.value = null;
    selectedImages.clear();
    // Reset to default privacy option
    if (privacyOptions.isNotEmpty) {
      selectedPrivacyOption.value = privacyOptions.first;
    }
  }
}