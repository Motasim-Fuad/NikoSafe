import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/auth_repo/auth_repositry.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import '../../../utils/utils.dart';

class ForgotPasswordController extends GetxController {
  final _authRepository = AuthRepository();

  final emailController = TextEditingController();
  final emailError = Rxn<String>();

  var isLoading = false.obs;

  bool validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      emailError.value = "Email cannot be empty";
      return false;
    }
    if (!GetUtils.isEmail(value.trim())) {
      emailError.value = "Enter a valid email";
      return false;
    }
    emailError.value = null;
    return true;
  }

  Future<void> sendPasswordResetRequest() async {
    final email = emailController.text.trim();

    if (!validateEmail(email)) {
      Utils.errorSnackBar("Validation Error", emailError.value ?? "Please enter valid email");
      return;
    }

    try {
      isLoading.value = true;

      final requestData = {
        "email": email,
      };

      print("Sending forgot password request for: $email");

      final response = await _authRepository.forgotPassword(requestData);

      print("Forgot password response: $response");

      if (response != null && response is Map && response['success'] == true) {
        Utils.successSnackBar("Success", response['message'] ?? "OTP sent to your email!");

        Get.toNamed(
            RouteName.otpVeryficationForPassResetView,
            arguments: {"email": email}
        );

        emailController.clear();
      } else {
        String errorMessage = response?['message'] ?? "Failed to send reset instructions";
        Utils.errorSnackBar("Error", errorMessage);
      }

    } catch (error) {
      print("Forgot password error: $error");

      String errorMessage = "Something went wrong";
      if (error.toString().contains('404')) {
        errorMessage = "Email not found";
      } else if (error.toString().contains('No Internet')) {
        errorMessage = "No internet connection";
      }

      Utils.errorSnackBar("Error", errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
}