import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nikosafe/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resource/App_routes/routes_name.dart';

class ServiceProviderAuthController extends GetxController {
  // Form Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final locationController = TextEditingController();
  final selectedJob = RxString('');

  // FocusNodes
  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();
  final locationFocus = FocusNode();


  // Error Fields
  final firstNameError = Rxn<String>();
  final lastNameError = Rxn<String>();
  final emailError = Rxn<String>();
  final phoneError = Rxn<String>();
  final passwordError = Rxn<String>();
  final locationError = Rxn<String>();
  final jobError = Rxn<String>();

  // UI State
  final isPasswordVisible = false.obs;
  final agreeTerms = false.obs;
  final loading = false.obs;
  final pickedImage = Rx<File?>(null);
  final rememberMe = false.obs;

  // Options
  final List<String> jobList = ["Plumber", "Electrician", "Cleaner", "Carpenter", "Painter","Trainer","Therapist"];

  // Validation Methods
  bool validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      firstNameError.value = "Name cannot be empty";
      return false;
    }
    firstNameError.value = null;
    return true;
  }
  bool validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      lastNameError.value = "Name cannot be empty";
      return false;
    }
    lastNameError.value = null;
    return true;
  }

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

  bool validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      phoneError.value = "Mobile Number cannot be empty";
      return false;
    }
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value.trim())) {
      phoneError.value = "Enter a valid mobile number (10-15 digits)";
      return false;
    }
    phoneError.value = null;
    return true;
  }

  bool validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      passwordError.value = "Password cannot be empty";
      return false;
    }
    if (value.length < 6) {
      passwordError.value = "Password must be at least 6 characters";
      return false;
    }
    passwordError.value = null;
    return true;
  }

  bool validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      locationError.value = "Location cannot be empty";
      return false;
    }
    locationError.value = null;
    return true;
  }

  bool validateJob(String? value) {
    if (value == null || value.isEmpty) {
      jobError.value = "Please select a job title";
      return false;
    }
    jobError.value = null;
    return true;
  }

  bool validateForm() {
    bool isValid = true;
    isValid = validateFirstName(firstNameController.text) && isValid;
    isValid = validateLastName(lastNameController.text) && isValid;
    isValid = validateEmail(emailController.text) && isValid;
    isValid = validatePhone(phoneController.text) && isValid;
    isValid = validatePassword(passwordController.text) && isValid;
    isValid = validateLocation(locationController.text) && isValid;
    isValid = validateJob(selectedJob.value) && isValid;
    return isValid;
  }

  // Image Picker
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      pickedImage.value = File(picked.path);
    } else {
      Utils.infoSnackBar("No Image", "No image selected");
    }
  }

  // Signup Method
  Future<void> signup() async {
    if (!agreeTerms.value) {
      Utils.infoSnackBar("Terms Required", "Please agree to the Terms & Conditions");
      return;
    }

    if (!validateForm()) {
      Utils.infoSnackBar("Input Error", "Please correct the errors in the form.");
      return;
    }

    loading.value = true;

    try {
      // Prepare service provider data
      Map<String, dynamic> providerData = {
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text,
        'location': locationController.text.trim(),
        'job': selectedJob.value,
        'role': 'service_provider',
      };

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Save to SharedPreferences (simulate success)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', 'service_provider_token_${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setString('role', 'service_provider');

      Utils.successSnackBar("Success", "Service Provider account created successfully");

      // Navigate to email verification
      Get.toNamed(RouteName.emailView, arguments: {
        "role": "service_provider",
        "email": emailController.text.trim()
      });

      clearForm();
    } catch (e) {
      Utils.errorSnackBar("Error", "Something went wrong: $e");
    } finally {
      loading.value = false;
    }
  }

  // Clear Form
  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    locationController.clear();
    selectedJob.value = '';

    firstNameError.value = null;
    lastNameError.value = null;
    emailError.value = null;
    phoneError.value = null;
    passwordError.value = null;
    locationError.value = null;
    jobError.value = null;

    agreeTerms.value = false;
    pickedImage.value = null;
  }

  // @override
  // void onClose() {
  //   nameController.dispose();
  //   emailController.dispose();
  //   phoneController.dispose();
  //   passwordController.dispose();
  //   locationController.dispose();

  // firstNameFocus.dispose();
  // lastNameFocus.dispose();
  // emailFocus.dispose();
  // phoneFocus.dispose();
  // passwordFocus.dispose();
  // locationFocus.dispose();
  //   super.onClose();
  // }
}