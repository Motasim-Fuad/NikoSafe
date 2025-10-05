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

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  final emailError = Rxn<String>();
  final passwordError = Rxn<String>();

  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final loading = false.obs;

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
      await TokenManager.clearAll();
      Utils.successSnackBar("Success", "Logged out successfully");
      Get.offAllNamed(RouteName.authView);
    } catch (e) {
      Utils.errorSnackBar("Error", "Logout failed: $e");
    }
  }

  // Login method - Single API endpoint
  Future<void> login() async {
    if (!validateForm()) {
      Utils.errorSnackBar("Input Error", "Please correct the errors in the login form.");
      return;
    }

    loading.value = true;

    try {
      final requestData = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };

      print("Login Request - Email: ${requestData['email']}");

      // Call single login API
      dynamic response = await _authRepository.login(requestData);

      print("Login Response: $response");

      if (response != null && response is Map) {
        bool isSuccess = response['success'] == true;

        if (isSuccess) {
          final data = response['data'];

          if (data != null && data['user'] != null) {
            final user = data['user'];
            final userType = user['user_type'] ?? '';

            // Save authentication data
            await TokenManager.saveAuthData(
              accessToken: data['access'] ?? '',
              refreshToken: data['refresh'] ?? '',
              userId: user['id'] ?? 0,
              email: user['email'] ?? emailController.text.trim(),
              fullName: user['full_name'] ?? '',
              additionalData: {
                'timestamp': response['timestamp'],
                'status_code': response['status_code'],
                'user_type': userType,
              },
            );

            print("Authentication successful");
            print("User ID: ${user['id']}");
            print("User Type: $userType");

            Utils.successSnackBar("Success", response['message'] ?? "Login successful!");

            // Navigate based on user_type from API
            _navigateBasedOnUserType(userType);

          } else {
            Utils.errorSnackBar("Error", "Invalid response data");
          }

        } else {
          String errorMessage = response['message']?.toString() ?? "Login failed";
          Utils.errorSnackBar("Login Failed", errorMessage);
        }
      } else {
        Utils.errorSnackBar("Error", "Invalid response from server");
      }

    } catch (e) {
      print("Login Error: $e");
      String errorMessage = _handleLoginError(e);
      Utils.errorSnackBar("Login Error", errorMessage);
    } finally {
      loading.value = false;
    }
  }

  // Navigate based on user_type from API response
  void _navigateBasedOnUserType(String userType) {
    switch (userType.toLowerCase()) {
      case 'basic':
      // Basic user - navigate to user dashboard
        Get.offAllNamed(RouteName.userBottomNavView);
        break;

      case 'service_provider':
      // Service provider - navigate to provider dashboard
        Get.offAllNamed(RouteName.providerBtmNavView);
        break;

      case 'hospitality_venue':
      // Hospitality venue - show message and logout
        Utils.infoSnackBar(
            "Access Restricted",
            "You can login on your given dashboard, not in app. Thank you."
        );
        // Clear session and redirect to login
        Future.delayed(Duration(seconds: 2), () {
          logout();
        });
        break;

      default:
      // Unknown user type - default to user dashboard
        print("Unknown user type: $userType - Navigating to user dashboard");
        Get.offAllNamed(RouteName.userBottomNavView);
        break;
    }
  }

  String _handleLoginError(dynamic error) {
    String errorString = error.toString();

    if (errorString.contains('400')) {
      return "Invalid email or password";
    } else if (errorString.contains('401')) {
      return "Invalid credentials";
    } else if (errorString.contains('403')) {
      return "Account access denied";
    } else if (errorString.contains('404')) {
      return "User not found";
    } else if (errorString.contains('422')) {
      return "Invalid input format";
    } else if (errorString.contains('No Internet')) {
      return "No internet connection";
    } else if (errorString.contains('timeout')) {
      return "Request timeout";
    }

    return "Something went wrong";
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    emailError.value = null;
    passwordError.value = null;
    isPasswordVisible.value = false;
    rememberMe.value = false;
  }
}