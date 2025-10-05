import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/utils/token_manager.dart';
import '../../../utils/utils.dart';
import '../../../Repositry/auth_repo/auth_repositry.dart';

class PasswordController extends GetxController {
  final _authRepository = AuthRepository();

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final newPasswordVisible = false.obs;
  final confirmPasswordVisible = false.obs;
  final loading = false.obs;

  final newPasswordError = Rxn<String>();
  final confirmPasswordError = Rxn<String>();

  late String email;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments?['email'] ?? '';
    print("Email for password setup: $email");
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

  Future<void> setPassword() async {
    if (!validateForm()) {
      Utils.errorSnackBar("Validation Error", "Please fix the errors above");
      return;
    }

    if (email.isEmpty) {
      Utils.errorSnackBar("Error", "Email not found");
      return;
    }

    loading.value = true;

    try {
      final requestData = {
        "email": email,
        "password": newPasswordController.text.trim(),
        "password2": confirmPasswordController.text.trim(),
      };

      print("Setting Password for: $email");

      final response = await _authRepository.setPassword(requestData);

      print("Set Password Response: $response");

      if (response != null && response is Map) {
        bool isSuccess = response['success'] == true;

        if (isSuccess) {
          final data = response['data'];

          if (data != null) {
            await TokenManager.saveAuthData(
              accessToken: data['access'] ?? '',
              refreshToken: data['refresh'] ?? '',
              userId: data['user']?['id'] ?? 0,
              email: data['user']?['email'] ?? email,
              fullName: data['user']?['full_name'] ?? '',
              additionalData: {
                'timestamp': response['timestamp'],
                'status_code': response['status_code'],
              },
            );

            print("Authentication data saved successfully");
            print("User ID: ${data['user']?['id']}");
          }

          Utils.successSnackBar("Success", response['message'] ?? "Password set successfully!");

          Get.offAllNamed(RouteName.authView);

        } else {
          String errorMessage = response['message']?.toString() ?? "Failed to set password";
          Utils.errorSnackBar("Error", errorMessage);
        }
      } else {
        Utils.errorSnackBar("Error", "Invalid response from server");
      }

    } catch (e) {
      print("Set Password Error: $e");

      String errorMessage = "Something went wrong";

      if (e.toString().contains('400')) {
        errorMessage = "Invalid password format";
      } else if (e.toString().contains('401')) {
        errorMessage = "Unauthorized. Please try registering again.";
      } else if (e.toString().contains('422')) {
        errorMessage = "Password validation failed.";
      } else if (e.toString().contains('No Internet')) {
        errorMessage = "No internet connection.";
      } else if (e.toString().contains('timeout')) {
        errorMessage = "Request timeout. Please try again.";
      }

      Utils.errorSnackBar("Error", errorMessage);
    } finally {
      loading.value = false;
    }
  }

  void clearForm() {
    newPasswordController.clear();
    confirmPasswordController.clear();
    newPasswordError.value = null;
    confirmPasswordError.value = null;
    newPasswordVisible.value = false;
    confirmPasswordVisible.value = false;
  }
}