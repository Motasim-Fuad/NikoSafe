import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userHome_repo/poll_repositry.dart';
import 'package:nikosafe/models/User/userHome/poll/create_poll_model.dart';
import 'package:nikosafe/utils/utils.dart';


class PollController extends GetxController {
  final titleController = TextEditingController();
  final textController = TextEditingController(); // Optional description
  final options = <TextEditingController>[
    TextEditingController(),
    TextEditingController(),
  ].obs; // Start with 2 options
  final isLoading = false.obs;

  final PollRepository _pollRepo = PollRepository();

  @override
  void onInit() {
    super.onInit();
    // Initialize with minimum 2 options
    if (options.length < 2) {
      options.add(TextEditingController());
    }
  }

  void addOption() {
    if (options.length < 6) { // Limit to 6 options
      options.add(TextEditingController());
    } else {
      Utils.infoSnackBar("Limit Reached", "Maximum 6 options allowed");
    }
  }

  void removeOption(int index) {
    if (options.length > 2) { // Minimum 2 options required
      options[index].dispose();
      options.removeAt(index);
    } else {
      Utils.infoSnackBar("Minimum Required", "At least 2 options required");
    }
  }

  Future<void> submitPoll() async {
    // Validation
    if (titleController.text.trim().isEmpty) {
      Utils.errorSnackBar("Validation Error", "Poll title is required");
      return;
    }

    // Check if at least 2 options are filled
    final filledOptions = options
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (filledOptions.length < 2) {
      Utils.errorSnackBar("Validation Error", "At least 2 options are required");
      return;
    }

    if (filledOptions.length > 6) {
      Utils.errorSnackBar("Validation Error", "Maximum 6 options allowed");
      return;
    }

    try {
      isLoading.value = true;

      final poll = PollModel(
        title: titleController.text.trim(),
        options: filledOptions,
        text: textController.text.trim().isEmpty
            ? "Choose wisely!"
            : textController.text.trim(),
        postType: '2', // Poll type
      );

      print('Submitting poll: ${poll.toJson()}');

      final response = await _pollRepo.createPoll(poll);

      if (response.success) {
        Utils.successSnackBar("Success", response.message);
        _clearForm();

        // // Navigate back after delay
        // Future.delayed(Duration(milliseconds: 1500), () {
        //   if (Get.canPop()) {
        //     Get.back();
        //   }
        // });
      } else {
        Utils.errorSnackBar("Error", response.message);
      }
    } catch (e) {
      print('Error submitting poll: $e');
      // More specific error handling
      String errorMessage = "Failed to create poll. Please try again.";

      if (e.toString().contains('type') && e.toString().contains('subtype')) {
        errorMessage = "Server response format error. Please try again.";
      } else if (e.toString().contains('connection') || e.toString().contains('network')) {
        errorMessage = "Network error. Please check your connection.";
      }

      Utils.errorSnackBar("Error", errorMessage);
    } finally {
      isLoading.value = false;
    }
  }

  void _clearForm() {
    // Dismiss keyboard
    if (Get.context != null) {
      FocusScope.of(Get.context!).unfocus();
    }

    // Clear controllers
    titleController.clear();
    textController.clear();

    // Clear and reset options to 2 empty ones
    for (var controller in options) {
      controller.dispose();
    }
    options.clear();
    options.addAll([
      TextEditingController(),
      TextEditingController(),
    ]);
  }

  @override
  void onClose() {
    titleController.dispose();
    textController.dispose();
    for (var controller in options) {
      controller.dispose();
    }
    super.onClose();
  }
}