import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/auth_repo/auth_repositry.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/utils/utils.dart';

class ResetPasswordController extends GetxController {
  final _authRepository = AuthRepository();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RxBool newPasswordVisible = false.obs;
  RxBool confirmPasswordVisible = false.obs;
  RxBool isLoading = false.obs;

  late String email;
  late String otp;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    email = arguments?['email'] ?? '';
    otp = arguments?['otp'] ?? '';
    print("Reset Password Controller initialized with email: $email, otp: $otp");
  }

  // @override
  // void onClose() {
  //   newPasswordController.dispose();
  //   confirmPasswordController.dispose();
  //   super.onClose();
  // }

  void toggleNewPasswordVisibility() {
    newPasswordVisible.value = !newPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisible.value = !confirmPasswordVisible.value;
  }

  // ✅ NEW: API integration for password reset
  Future<void> updatePassword() async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Validation
    if (newPassword.isEmpty) {
      Utils.tostMassage("Please enter new password");
      return;
    }

    if (confirmPassword.isEmpty) {
      Utils.tostMassage("Please confirm your password");
      return;
    }

    if (newPassword.length < 6) {
      Utils.tostMassage("Password must be at least 6 characters long");
      return;
    }

    if (newPassword != confirmPassword) {
      Utils.tostMassage("Passwords do not match");
      return;
    }

    try {
      isLoading.value = true;

      final requestData = {
        "email": email,
        "otp": otp,
        "new_password": newPassword,
        "new_password2": confirmPassword,
      };

      print("Updating password: ${requestData.keys}"); // Don't log passwords

      final response = await _authRepository.confirmPasswordReset(requestData);

      print("Password reset response: $response");

      if (response['success'] == true) {
        Utils.successSnackBar("Success", response['message'] ?? "Password updated successfully!");

        // Navigate back to login
        Get.offAllNamed(RouteName.authView);
      } else {
        Utils.tostMassage(response['message'] ?? "Failed to update password");
      }

    } catch (error) {
      print("Password reset error: $error");
      Utils.tostMassage("Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }
}