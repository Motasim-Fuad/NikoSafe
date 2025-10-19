import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/FAQ&suport/suport_repo.dart';
import 'package:nikosafe/models/FAQ&Suport/suport_model.dart';
import '../../../utils/utils.dart';
import '../../../utils/token_manager.dart';

class SuportController extends GetxController {
  final isLoading = false.obs;
  final SuportRepository _repo = SuportRepository();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final titleFocus = FocusNode();
  final descriptionFocus = FocusNode();

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    titleFocus.dispose();
    descriptionFocus.dispose();
    super.onClose();
  }

  // Get user type from auth
  Future<String> getUserType() async {
    final userData = await TokenManager.getUserData();

    if (userData != null && userData['user_type'] != null) {
      String type = userData['user_type'].toString().toLowerCase();

      // 🔁 Map local user types to backend-accepted ones
      if (type == 'basic') {
        type = 'user';
      } else if (type == 'service_provider') {
        type = 'provider';
      }

      // ✅ Ensure it’s one of the allowed backend values
      if (!['user', 'provider', 'hospitality', 'admin'].contains(type)) {
        type = 'user'; // fallback default
      }

      return type;
    }

    return 'user'; // fallback if no user data
  }



  Future<void> submitSuport() async {
    if (titleController.text.trim().isEmpty) {
      Utils.errorSnackBar("Error", "Please enter issue title");
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      Utils.errorSnackBar("Error", "Please enter issue description");
      return;
    }

    try {
      isLoading.value = true;

      // Get user type from auth
      final userType = await getUserType();

      final ticket = SuportModel(
        userType: userType,
        subject: titleController.text.trim(),
        description: descriptionController.text.trim(),
        priority: 'high', // Always set to high as per your requirement
      );

      await _repo.createTicket(ticket);
      Utils.successSnackBar("Success", "Your support ticket has been submitted successfully");
      // Clear form
      titleController.clear();
      descriptionController.clear();
      FocusScope.of(Get.context!).unfocus();



      // Optionally navigate back
      Get.back();

    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to submit ticket: $e");
      print('Error submitting ticket: $e');
    } finally {
      isLoading.value = false;
    }
  }
}