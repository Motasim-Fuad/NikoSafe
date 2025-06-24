import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/view/vendor/vendorHome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resource/App_routes/routes_name.dart';

class LoginAuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final selectedRole = 'user'.obs;

  final emailError = Rxn<String>();
  final passwordError = Rxn<String>();

  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final loading = false.obs;

  // Role options for login
  final List<String> roleOptions = ['user', 'service_provider', 'vendor'];

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
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Clear token and other user data
      await prefs.clear();

      // Optionally reset observable profile if needed
      // profile.value = MyProfileModel(
      //   name: "",
      //   points: 0,
      //   profileImage: ImageAssets.userHome_userProfile,
      // );

      // Navigate to login screen
      Get.offAllNamed(RouteName.authView); // Replace with your login route
    } catch (e) {
      Get.snackbar("Error", "Logout failed: $e");
    }
  }


  Future<void> login() async {
    if (!validateForm()) {
      Get.snackbar("Input Error", "Please correct the errors in the login form.");
      return;
    }

    loading.value = true;

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Hardcoded credentials for demonstration
      final email = emailController.text.trim();
      final password = passwordController.text;
      final role = selectedRole.value;

      // Check credentials based on selected role
      bool isValidCredentials = false;
      if (role == 'user' && password == 'password123') {
        isValidCredentials = true;
      } else if (role == 'service_provider' && password == 'password123') {
        isValidCredentials = true;
      } else if (role == 'vendor' && password == 'password123') {
        isValidCredentials = true;
      }

      if (isValidCredentials) {
        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', '${role}_token_${DateTime.now().millisecondsSinceEpoch}');
        await prefs.setString('role', role);
        await prefs.setBool('isVerified', true);

        Get.snackbar("Success", "Logged in successfully as $role");

        // Navigate to appropriate screen based on role
        switch (role) {
          case 'user':
            Get.offNamed(RouteName.userBottomNavView);
            break;
          case 'service_provider':
            Get.offNamed(RouteName.providerBtmNavView);
            break;
          case 'vendor':
            Get.off(Vendorhome());
            // hare will be vendor screen
            break;
        }
      } else {
        Get.snackbar("Error", "Invalid credentials for selected role. Try password: password123");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      loading.value = false;
    }
  }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   super.onClose();
  // }
}