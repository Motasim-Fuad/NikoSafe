import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/auth_repo/auth_repositry.dart';

import 'package:nikosafe/resource/App_routes/routes_name.dart';
import '../../../utils/utils.dart';

class ForgotPasswordController extends GetxController {
  final _authRepository = AuthRepository();

  final emailController = TextEditingController();

  var isLoading = false.obs;

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   super.onClose();
  // }

  Future<void> sendPasswordResetRequest() async {
    final email = emailController.text.trim();

    // Validation
    if (email.isEmpty) {
      Utils.tostMassage("Please enter your email.");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Utils.tostMassage("Please enter a valid email address.");
      return;
    }

    try {
      isLoading.value = true;

      final requestData = {
        "email": email,
      };

      print("Sending forgot password request for email: $email");

      final response = await _authRepository.forgotPassword(requestData);

      print("Forgot password response: $response");

      // Handle success response
      if (response['success'] == true) {
        Utils.tostMassage(response['message'] ?? "Password reset instructions sent to your email!");

        // Navigate to OTP verification screen
        Get.toNamed(
            RouteName.otpVeryficationForPassResetView,
            arguments: {"email": email}
        );
      } else {
        Utils.tostMassage(response['message'] ?? "Failed to send reset instructions");
      }

    } catch (error) {
      print("Forgot password error: $error");
      Utils.tostMassage("Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }
}



























