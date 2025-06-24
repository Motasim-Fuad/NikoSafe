import 'package:get/get.dart';

class MainAuthController extends GetxController {
  // UI State
  final isLogin = true.obs;
  final selectedRole = 'user'.obs; // 'user', 'service_provider', 'vendor'

  // Switch between Login and Signup
  void toggleAuthMode() {
    isLogin.value = !isLogin.value;
  }

  // Switch to Login
  void switchToLogin() {
    isLogin.value = true;
  }

  // Switch to Signup
  void switchToSignup() {
    isLogin.value = false;
  }

  // Set Role
  void setRole(String role) {
    selectedRole.value = role;
  }

  // Reset to default state
  void reset() {
    isLogin.value = true;
    selectedRole.value = 'user';
  }
}