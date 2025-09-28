import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/utils/token_manager.dart';
import 'package:nikosafe/utils/utils.dart';
import '../../../resource/App_routes/routes_name.dart';
import '../../../Repositry/auth_repo/auth_repositry.dart';


class LoginAuthController extends GetxController {
  final _authRepository = AuthRepository();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //focus node
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  final emailError = Rxn<String>();
  final passwordError = Rxn<String>();

  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final loading = false.obs;

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   emailFocus.dispose();
  //   passwordFocus.dispose();
  //   super.onClose();
  // }

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

  bool validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      passwordError.value = "Password cannot be empty";
      return false;
    }
    passwordError.value = null;
    return true;
  }

  bool validateForm() {
    bool isValid = true;
    isValid = validateEmail(emailController.text) && isValid;
    isValid = validatePassword(passwordController.text) && isValid;
    return isValid;
  }

  Future<void> logout() async {
    try {
      // Clear all stored authentication data
      await TokenManager.clearAll();

      Utils.successSnackBar("Success", "Logged out successfully");

      // Navigate to login screen
      Get.offAllNamed(RouteName.authView);
    } catch (e) {
      Utils.errorSnackBar("Error", "Logout failed: $e");
    }
  }

  Future<void> login() async {
    if (!validateForm()) {
      Utils.errorSnackBar("Input Error", "Please correct the errors in the login form.");
      return;
    }

    loading.value = true;

    try {
      // Prepare login data matching your Postman request
      final requestData = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };

      print("🔐 Login Request:");
      print("Email: ${requestData['email']}");

      // Call login API
      final response = await _authRepository.loginUser(requestData);

      print("📡 Login Response: $response");

      if (response != null && response is Map) {
        bool isSuccess = response['success'] == true;

        if (isSuccess) {
          // Extract data from response
          final data = response['data'];

          if (data != null) {
            // Save authentication data using TokenManager
            await TokenManager.saveAuthData(
              accessToken: data['access'] ?? '',
              refreshToken: data['refresh'] ?? '',
              userId: data['user']?['id'] ?? 0,
              email: data['user']?['email'] ?? emailController.text.trim(),
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

            Utils.successSnackBar("Success",
                response['message'] ?? "Login successful!");

            // Since backend manages role, navigate to appropriate screen
            // You can add role-based navigation logic here if needed
            Get.offAllNamed(RouteName.userBottomNavView); // Default navigation

          } else {
            Utils.errorSnackBar("Error", "Invalid response data");
          }

        } else {
          String errorMessage = "Login failed";
          if (response['message'] != null) {
            errorMessage = response['message'].toString();
          }
          Utils.errorSnackBar("Login Failed", errorMessage);
        }
      } else {
        Utils.errorSnackBar("Error", "Invalid response from server");
      }

    } catch (e) {
      print("❌ Login Error: $e");

      String errorMessage = "Something went wrong";

      if (e.toString().contains('400')) {
        errorMessage = "Invalid email or password";
      } else if (e.toString().contains('401')) {
        errorMessage = "Invalid credentials. Please check your email and password.";
      } else if (e.toString().contains('403')) {
        errorMessage = "Account access denied. Please contact support.";
      } else if (e.toString().contains('404')) {
        errorMessage = "User not found. Please check your email.";
      } else if (e.toString().contains('422')) {
        errorMessage = "Invalid input format.";
      } else if (e.toString().contains('No Internet')) {
        errorMessage = "No internet connection. Please check your network.";
      } else if (e.toString().contains('timeout')) {
        errorMessage = "Request timeout. Please try again.";
      }

      Utils.errorSnackBar("Login Error", errorMessage);
    } finally {
      loading.value = false;
    }
  }

  // Clear login form
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    emailError.value = null;
    passwordError.value = null;
    isPasswordVisible.value = false;
    rememberMe.value = false;
  }
}