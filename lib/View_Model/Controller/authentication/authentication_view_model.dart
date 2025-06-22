
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Repositry/auth_repo/auth_repositry.dart';

class AuthViewModel extends GetxController {
  final isLogin = true.obs;
  final isUser = true.obs; // true for User, false for Service Provider
  final isVendor = false.obs; // NEW: Track vendor role
  final loading = false.obs;

  // --- Login Form Controllers and Validation ---
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final loginEmailError = Rxn<String>();
  final loginPasswordError = Rxn<String>();

  // --- User Signup Form Controllers and Validation ---
  final userNameController = TextEditingController();
  final userPhoneController = TextEditingController();
  final userAgeController = TextEditingController();
  final userWeightController = TextEditingController();
  final userEmailController = TextEditingController();
  final userPasswordController = TextEditingController();
  final userSelectedSex = ''.obs; // For User Sex Dropdown

  final userNameError = Rxn<String>();
  final userPhoneError = Rxn<String>();
  final userAgeError = Rxn<String>();
  final userWeightError = Rxn<String>();
  final userEmailError = Rxn<String>();
  final userPasswordError = Rxn<String>();
  final userSexError = Rxn<String>();

  // --- Service Provider Signup Form Controllers and Validation ---
  final providerNameController = TextEditingController();
  final providerEmailController = TextEditingController();
  final providerPhoneController = TextEditingController();
  final providerPasswordController = TextEditingController();

  final providerLocationController = TextEditingController();
  final providerSelectedJob = RxString('');

  final providerNameError = Rxn<String>();
  final providerEmailError = Rxn<String>();
  final providerPhoneError = Rxn<String>();
  final providerPasswordError = Rxn<String>();

  final providerLocationError = Rxn<String>();
  final providerJobError = Rxn<String>();

  // --- Common properties ---



  RxBool isPasswordVisible = false.obs; // For both login and signup passwords
  final List<String> jobList = ["Plumber", "Electrician", "Cleaner"];
  final List<String> sexOptions = ["Male", "Female", "Other"];
  final agreeTerms = true.obs; // Applies to both signup roles

  late final String role; // Determined from arguments on Init

  // Update role detection from args
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    if (args != null && args is Map && args.containsKey('role')) {
      role = args['role'];
    } else {
      role = 'user';
      debugPrint("⚠️ Warning: 'role' argument not passed to AuthViewModel.");
    }

    isUser.value = role == 'user';
    isVendor.value = role == 'vendor';
  }

  // --- Login Validation Methods ---
  bool validateLoginEmail(String? value) {
    if (value == null || value.isEmpty) {
      loginEmailError.value = "Email cannot be empty";
      return false;
    }
    if (!GetUtils.isEmail(value)) {
      loginEmailError.value = "Enter a valid email";
      return false;
    }
    loginEmailError.value = null;
    return true;
  }

  bool validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      loginPasswordError.value = "Password cannot be empty";
      return false;
    }
    loginPasswordError.value = null;
    return true;
  }

  bool validateLoginForm() {
    bool isValid = true;
    isValid = validateLoginEmail(loginEmailController.text) && isValid;
    isValid = validateLoginPassword(loginPasswordController.text) && isValid;
    return isValid;
  }

  // --- User Signup Validation Methods ---
  bool validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      userNameError.value = "Name cannot be empty";
      return false;
    }
    userNameError.value = null;
    return true;
  }

  bool validateUserEmail(String? value) {
    if (value == null || value.isEmpty) {
      userEmailError.value = "Email cannot be empty";
      return false;
    }
    if (!GetUtils.isEmail(value)) {
      userEmailError.value = "Enter a valid email";
      return false;
    }
    userEmailError.value = null;
    return true;
  }

  bool validateUserPhone(String? value) {
    if (value == null || value.isEmpty) {
      userPhoneError.value = "Mobile Number cannot be empty";
      return false;
    }
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
      userPhoneError.value = "Enter a valid mobile number (10-15 digits)";
      return false;
    }
    userPhoneError.value = null;
    return true;
  }

  bool validateUserPassword(String? value) {
    if (value == null || value.isEmpty) {
      userPasswordError.value = "Password cannot be empty";
      return false;
    }
    if (value.length < 6) {
      userPasswordError.value = "Password must be at least 6 characters";
      return false;
    }
    userPasswordError.value = null;
    return true;
  }

  bool validateUserAge(String? value) {
    if (value == null || value.isEmpty) {
      userAgeError.value = "Age cannot be empty";
      return false;
    }
    final int? age = int.tryParse(value);
    if (age == null || age < 0 || age > 200) {
      userAgeError.value = "Age must be between 0 and 200";
      return false;
    }
    userAgeError.value = null;
    return true;
  }

  bool validateUserWeight(String? value) {
    if (value == null || value.isEmpty) {
      userWeightError.value = "Weight cannot be empty";
      return false;
    }
    final int? weight = int.tryParse(value);
    if (weight == null || weight < 0 || weight > 200) {
      userWeightError.value = "Weight must be between 0 and 200";
      return false;
    }
    userWeightError.value = null;
    return true;
  }

  bool validateUserSex(String? value) {
    if (value == null || value.isEmpty) {
      userSexError.value = "Please select your sex";
      return false;
    }
    userSexError.value = null;
    return true;
  }

  bool validateUserSignupForm() {
    bool isValid = true;
    isValid = validateUserName(userNameController.text) && isValid;
    isValid = validateUserEmail(userEmailController.text) && isValid;
    isValid = validateUserPhone(userPhoneController.text) && isValid;
    isValid = validateUserPassword(userPasswordController.text) && isValid;
    isValid = validateUserAge(userAgeController.text) && isValid;
    isValid = validateUserWeight(userWeightController.text) && isValid;
    isValid = validateUserSex(userSelectedSex.value) && isValid;
    return isValid;
  }

  // --- Service Provider Signup Validation Methods ---
  bool validateProviderName(String? value) {
    if (value == null || value.isEmpty) {
      providerNameError.value = "Name cannot be empty";
      return false;
    }
    providerNameError.value = null;
    return true;
  }

  bool validateProviderEmail(String? value) {
    if (value == null || value.isEmpty) {
      providerEmailError.value = "Email cannot be empty";
      return false;
    }
    if (!GetUtils.isEmail(value)) {
      providerEmailError.value = "Enter a valid email";
      return false;
    }
    providerEmailError.value = null;
    return true;
  }

  bool validateProviderPhone(String? value) {
    if (value == null || value.isEmpty) {
      providerPhoneError.value = "Mobile Number cannot be empty";
      return false;
    }
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
      providerPhoneError.value = "Enter a valid mobile number (10-15 digits)";
      return false;
    }
    providerPhoneError.value = null;
    return true;
  }

  bool validateProviderPassword(String? value) {
    if (value == null || value.isEmpty) {
      providerPasswordError.value = "Password cannot be empty";
      return false;
    }
    if (value.length < 6) {
      providerPasswordError.value = "Password must be at least 6 characters";
      return false;
    }
    providerPasswordError.value = null;
    return true;
  }

  bool validateProviderJobTitle(String? value) {
    if (value == null || value.isEmpty) {
      providerJobError.value = "Please select a job title";
      return false;
    }
    providerJobError.value = null;
    return true;
  }



  bool validateProviderLocation(String? value) {
    if (value == null || value.isEmpty) {
      providerLocationError.value = "Location cannot be empty";
      return false;
    }
    providerLocationError.value = null;
    return true;
  }

  bool validateProviderSignupForm() {
    bool isValid = true;
    isValid = validateProviderName(providerNameController.text) && isValid;
    isValid = validateProviderEmail(providerEmailController.text) && isValid;
    isValid = validateProviderPhone(providerPhoneController.text) && isValid;
    isValid = validateProviderPassword(providerPasswordController.text) && isValid;
    isValid = validateProviderJobTitle(providerSelectedJob.value) && isValid;

    isValid = validateProviderLocation(providerLocationController.text) && isValid;
    return isValid;
  }

  // --- Auth Logic ---
  Future<void> login() async {
    if (!validateLoginForm()) {
      Get.snackbar("Input Error", "Please correct the errors in the login form.");
      return;
    }

    loading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    loading.value = false;

    // Hardcoded successful login for demonstration
    if (loginEmailController.text == "test@example.com" && loginPasswordController.text == "password123") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', 'dummy_token'); // Store a dummy token
      await prefs.setString('role', isUser.value ? 'user' : 'sub_admin'); // Store actual role

      Get.snackbar("Success", "Logged in successfully");

      if (role == 'user') {
        Get.offNamed(RouteName.userBottomNavView);
      } else if (role == 'sub_admin') {
        Get.offNamed(RouteName.providerBtmNavView);
      }
      clearLoginFields(); // Clear login fields after successful login
    } else {
      Get.snackbar("Error", "Invalid credentials");
    }
  }
  Future<void> signup() async {
    if (!agreeTerms.value) {
      Get.snackbar("Terms Required", "Please agree to the Terms & Conditions");
      return;
    }

    bool formIsValid = false;

    if (isUser.value) {
      formIsValid = validateUserSignupForm();
    } else {
      formIsValid = validateProviderSignupForm(); // Vendor & Provider share fields for now
    }

    if (!formIsValid) {
      Get.snackbar("Input Error", "Please correct the errors in the form.");
      return;
    }

    loading.value = true;

    // Prepare dummy data (no API call for now)
    Map<String, String> data = {};
    String selectedRole = '';

    if (isUser.value) {
      selectedRole = 'user';
      data = {
        'email': userEmailController.text.trim(),
        'name': userNameController.text.trim(),
        'phoneNumber': userPhoneController.text.trim(),
        'password': userPasswordController.text,
        'role': selectedRole,
        'age': userAgeController.text.trim(),
        'weight': userWeightController.text.trim(),
        'sex': userSelectedSex.value,
      };
    } else if (isVendor.value) {
      selectedRole = 'vendor';
      data = {
        'email': providerEmailController.text.trim(),
        'name': providerNameController.text.trim(),
        'phoneNumber': providerPhoneController.text.trim(),
        'password': providerPasswordController.text,
        'role': selectedRole,
        'location': providerLocationController.text.trim(),
      };
    } else {
      selectedRole = 'sub_admin';
      data = {
        'email': providerEmailController.text.trim(),
        'name': providerNameController.text.trim(),
        'phoneNumber': providerPhoneController.text.trim(),
        'password': providerPasswordController.text,
        'role': selectedRole,
        'job': providerSelectedJob.value,
        'location': providerLocationController.text,
      };
    }

    await Future.delayed(const Duration(seconds: 2)); // Simulate API delay
    loading.value = false;

    try {
      // Simulate successful signup and save data locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', 'dummy_token_${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setString('role', selectedRole);

      Get.snackbar("Success", "Signed up successfully as $selectedRole");

      // Navigate to email verification screen or home
      Get.toNamed(RouteName.emailView, arguments: {"role": selectedRole});

      // Clear fields
      if (isUser.value) {
        clearUserSignupFields();
      } else {
        clearProviderSignupFields();
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }


  // --- Clear Form Fields Methods ---
  void clearLoginFields() {
    loginEmailController.clear();
    loginPasswordController.clear();
    loginEmailError.value = null;
    loginPasswordError.value = null;
  }

  void clearUserSignupFields() {
    userNameController.clear();
    userEmailController.clear();
    userPhoneController.clear();
    userPasswordController.clear();
    userAgeController.clear();
    userWeightController.clear();
    userSelectedSex.value = '';

    userNameError.value = null;
    userEmailError.value = null;
    userPhoneError.value = null;
    userPasswordError.value = null;
    userAgeError.value = null;
    userWeightError.value = null;
    userSexError.value = null;
    agreeTerms.value = false;
    pickedImage.value = null;
  }

  void clearProviderSignupFields() {
    providerNameController.clear();
    providerEmailController.clear();
    providerPhoneController.clear();
    providerPasswordController.clear();
    providerLocationController.clear();
    providerSelectedJob.value = '';
    providerNameError.value = null;
    providerEmailError.value = null;
    providerPhoneError.value = null;
    providerPasswordError.value = null;
    providerLocationError.value = null;
    providerJobError.value = null;
    agreeTerms.value = false;
    pickedImage.value = null;
  }

  // --- Image Picker ---
  Rx<File?> pickedImage = Rx<File?>(null);
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      pickedImage.value = File(picked.path);
    } else {
      Get.snackbar("No Image", "No image selected");
    }
  }

  // --- Logout ---
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    clearLoginFields();
    clearUserSignupFields();
    clearProviderSignupFields();
    pickedImage.value = null;

    Get.offAllNamed(RouteName.authView);
    Get.snackbar("Logged out", "You have been successfully logged out");
  }
}