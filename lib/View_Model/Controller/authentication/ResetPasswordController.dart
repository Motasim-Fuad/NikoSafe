import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/auth_repo/auth_repositry.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/utils/utils.dart';

class ResetPasswordController extends GetxController {
  final _authRepository = AuthRepository();

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final newPasswordError = Rxn<String>();
  final confirmPasswordError = Rxn<String>();

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
    print("Reset Password - Email: $email");
  }

  void toggleNewPasswordVisibility() {
    newPasswordVisible.value = !newPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisible.value = !confirmPasswordVisible.value;
  }

  bool validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      newPasswordError.value = "Password cannot be empty";
      return false;
    }
    if (value.length < 8) {
      newPasswordError.value = "Password must be at least 8 characters";
      return false;
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      newPasswordError.value = "Password must contain uppercase, lowercase and number";
      return false;
    }
    newPasswordError.value = null;
    return true;
  }

  bool validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      confirmPasswordError.value = "Please confirm your password";
      return false;
    }
    if (value != newPasswordController.text) {
      confirmPasswordError.value = "Passwords do not match";
      return false;
    }
    confirmPasswordError.value = null;
    return true;
  }

  bool validateForm() {
    bool isValid = true;
    isValid = validateNewPassword(newPasswordController.text) && isValid;
    isValid = validateConfirmPassword(confirmPasswordController.text) && isValid;
    return isValid;
  }

  Future<void> updatePassword() async {
    if (!validateForm()) {
      Utils.errorSnackBar("Validation Error", "Please fix the errors above");
      return;
    }

    if (email.isEmpty || otp.isEmpty) {
      Utils.errorSnackBar("Error", "Session expired. Please try again.");
      Get.offAllNamed(RouteName.forgotPasswordView);
      return;
    }

    try {
      isLoading.value = true;

      final requestData = {
        "email": email,
        "otp": otp,
        "new_password": newPasswordController.text.trim(),
        "new_password2": confirmPasswordController.text.trim(),
      };

      print("Updating password for: $email");

      final response = await _authRepository.confirmPasswordReset(requestData);

      print("Password reset response: $response");

      if (response != null && response is Map && response['success'] == true) {
        Utils.successSnackBar("Success", response['message'] ?? "Password updated successfully!");

        newPasswordController.clear();
        confirmPasswordController.clear();

        Get.offAllNamed(RouteName.authView);
      } else {
        String errorMessage = response?['message'] ?? "Failed to update password";
        Utils.errorSnackBar("Error", errorMessage);
      }

    } catch (error) {
      print("Password reset error: $error");

      String errorMessage = "Something went wrong";
      if (error.toString().contains('400')) {
        errorMessage = "Invalid password format";
      } else if (error.toString().contains('401')) {
        errorMessage = "OTP expired. Please request a new one.";
      } else if (error.toString().contains('No Internet')) {
        errorMessage = "No internet connection";
      }

      Utils.errorSnackBar("Error", errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
}