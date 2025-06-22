import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class VendorSignupViewModel extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final locationController = TextEditingController();

  final nameError = Rxn<String>();
  final emailError = Rxn<String>();
  final phoneError = Rxn<String>();
  final passwordError = Rxn<String>();
  final locationError = Rxn<String>();
  final isPasswordVisible = false.obs;
  // final agreeTerms = true.obs;
  final loading = false.obs;

  Rx<File?> pickedImage = Rx<File?>(null);

  // --- Validation ---
  bool validateAll() {
    bool isValid = true;
    isValid = _validateField(nameController.text, nameError, "Business Name") && isValid;
    isValid = _validateEmail(emailController.text) && isValid;
    isValid = _validatePhone(phoneController.text) && isValid;
    isValid = _validatePassword(passwordController.text) && isValid;
    isValid = _validateField(locationController.text, locationError, "Address") && isValid;
    return isValid;
  }

  bool _validateField(String value, Rxn<String> errorField, String fieldName) {
    if (value.trim().isEmpty) {
      errorField.value = "$fieldName cannot be empty";
      return false;
    }
    errorField.value = null;
    return true;
  }

  bool _validateEmail(String value) {
    if (value.trim().isEmpty || !GetUtils.isEmail(value)) {
      emailError.value = "Enter a valid email";
      return false;
    }
    emailError.value = null;
    return true;
  }

  bool _validatePhone(String value) {
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
      phoneError.value = "Enter valid phone number";
      return false;
    }
    phoneError.value = null;
    return true;
  }

  bool _validatePassword(String value) {
    if (value.length < 6) {
      passwordError.value = "Min 6 characters";
      return false;
    }
    passwordError.value = null;
    return true;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      pickedImage.value = File(picked.path);
    } else {
      Get.snackbar("No Image", "No image selected");
    }
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    locationController.clear();
    nameError.value = null;
    emailError.value = null;
    phoneError.value = null;
    passwordError.value = null;
    locationError.value = null;
    pickedImage.value = null;
    // agreeTerms.value = false;
  }
}
