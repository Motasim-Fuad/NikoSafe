import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:nikosafe/utils/token_manager.dart';
import '../../../utils/utils.dart';
import '../../../Repositry/auth_repo/auth_repositry.dart';
class PasswordController extends GetxController {
  final _authRepository = AuthRepository();

  // Form Controllers
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // UI State
  final newPasswordVisible = false.obs;
  final confirmPasswordVisible = false.obs;
  final loading = false.obs;

  // Error handling
  final newPasswordError = Rxn<String>();
  final confirmPasswordError = Rxn<String>();

  late String email;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments?['email'] ?? '';
    print("📧 Email for password setup: $email");
  }

  // @override
  // void onClose() {
  //   newPasswordController.dispose();
  //   confirmPasswordController.dispose();
  //   super.onClose();
  // }

  // Toggle password visibility
  void toggleNewPasswordVisibility() {
    newPasswordVisible.value = !newPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisible.value = !confirmPasswordVisible.value;
  }

  // Validation methods
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

  // Set Password API call
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
      // Prepare data matching your Postman request
      final requestData = {
        "email": email,
        "password": newPasswordController.text.trim(),
        "password2": confirmPasswordController.text.trim(),
      };

      print("🔐 Setting Password:");
      print("Email: $email");
      print("Password length: ${newPasswordController.text.length}");

      // Call set password API
      final response = await _authRepository.setPassword(requestData);

      print("📡 Set Password Response: $response");

      if (response != null && response is Map) {
        bool isSuccess = response['success'] == true;

        if (isSuccess) {
          // Extract tokens and user data from response
          final data = response['data'];

          if (data != null) {
            // Save authentication data using TokenManager
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

            print("✅ Authentication data saved successfully");
            print("User ID: ${data['user']?['id']}");
            print("Email: ${data['user']?['email']}");
            print("Full Name: ${data['user']?['full_name']}");
          }

          Utils.successSnackBar("Success",
              response['message'] ?? "Password set successfully!");

          // Navigate to main app
          Get.offAllNamed(RouteName.authView); // or your dashboard route

        } else {
          String errorMessage = "Failed to set password";
          if (response['message'] != null) {
            errorMessage = response['message'].toString();
          }
          Utils.errorSnackBar("Error", errorMessage);
        }
      } else {
        Utils.errorSnackBar("Error", "Invalid response from server");
      }

    } catch (e) {
      print("❌ Set Password Error: $e");

      String errorMessage = "Something went wrong";

      if (e.toString().contains('400')) {
        errorMessage = "Invalid password format. Please check requirements.";
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

  // Clear form
  void clearForm() {
    newPasswordController.clear();
    confirmPasswordController.clear();
    newPasswordError.value = null;
    confirmPasswordError.value = null;
    newPasswordVisible.value = false;
    confirmPasswordVisible.value = false;
  }
}