import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nikosafe/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resource/App_routes/routes_name.dart';

class UserAuthController extends GetxController {
  // Form Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final selectedSex = ''.obs;

  // Error Fields
  final nameError = Rxn<String>();
  final emailError = Rxn<String>();
  final phoneError = Rxn<String>();
  final passwordError = Rxn<String>();
  final ageError = Rxn<String>();
  final weightError = Rxn<String>();
  final sexError = Rxn<String>();

  // UI State
  final isPasswordVisible = false.obs;
  final agreeTerms = false.obs;
  final loading = false.obs;
  final pickedImage = Rx<File?>(null);
  final rememberMe = false.obs;

  // Options
  final List<String> sexOptions = ["Male", "Female", "Other"];

  // Validation Methods
  bool validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      nameError.value = "Name cannot be empty";
      return false;
    }
    nameError.value = null;
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

  bool validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      ageError.value = "Age cannot be empty";
      return false;
    }
    final int? age = int.tryParse(value.trim());
    if (age == null || age < 0 || age > 200) {
      ageError.value = "Age must be between 0 and 200";
      return false;
    }
    ageError.value = null;
    return true;
  }

  bool validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) {
      weightError.value = "Weight cannot be empty";
      return false;
    }
    final double? weight = double.tryParse(value.trim());
    if (weight == null || weight < 0 || weight > 500) {
      weightError.value = "Weight must be between 0 and 500";
      return false;
    }
    weightError.value = null;
    return true;
  }

  bool validateSex(String? value) {
    if (value == null || value.isEmpty) {
      sexError.value = "Please select your gender";
      return false;
    }
    sexError.value = null;
    return true;
  }

  bool validateForm() {
    bool isValid = true;
    isValid = validateName(nameController.text) && isValid;
    isValid = validateEmail(emailController.text) && isValid;
    isValid = validatePhone(phoneController.text) && isValid;
    isValid = validatePassword(passwordController.text) && isValid;
    isValid = validateAge(ageController.text) && isValid;
    isValid = validateWeight(weightController.text) && isValid;
    isValid = validateSex(selectedSex.value) && isValid;
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
      Utils.errorSnackBar("Input Error", "Please correct the errors in the form.");
      return;
    }

    loading.value = true;

    try {
      // Prepare user data
      Map<String, dynamic> userData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text,
        'age': ageController.text.trim(),
        'weight': weightController.text.trim(),
        'sex': selectedSex.value,
        'role': 'user',
      };

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Save to SharedPreferences (simulate success)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', 'user_token_${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setString('role', 'user');

     Utils.successSnackBar("Success", "User account created successfully");

      // Navigate to email verification
      Get.toNamed(RouteName.emailView, arguments: {
        "role": "user",
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
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    ageController.clear();
    weightController.clear();
    selectedSex.value = '';

    nameError.value = null;
    emailError.value = null;
    phoneError.value = null;
    passwordError.value = null;
    ageError.value = null;
    weightError.value = null;
    sexError.value = null;

    agreeTerms.value = false;
    pickedImage.value = null;
  }



  // ai ta jokon ek bar textfield use hoba orthand user jodi ekbar register kora ta hola ai text ar use korta parba ,  ai ta api call korar somoy handale kora diba , ar ai ta dila valo hoy
  // @override
  // void onClose() {
  //   nameController.dispose();
  //   emailController.dispose();
  //   phoneController.dispose();
  //   passwordController.dispose();
  //   ageController.dispose();
  //   weightController.dispose();
  //   super.onClose();
  // }
}