import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/auth_repo/auth_repositry.dart';
import 'package:nikosafe/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resource/App_routes/routes_name.dart';

class UserAuthController extends GetxController {
  final _authRepository = AuthRepository();

  // Form Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();

  // Focus Nodes
  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();
  final ageFocus = FocusNode();
  final weightFocus = FocusNode();
  final selectedSex = ''.obs;

  // Error Fields
  final firstnameError = Rxn<String>();
  final lastnameError = Rxn<String>();
  final emailError = Rxn<String>();
  final phoneError = Rxn<String>();
  final ageError = Rxn<String>();
  final weightError = Rxn<String>();
  final sexError = Rxn<String>();

  // UI State
  final agreeTerms = false.obs;
  final loading = false.obs;

  // Options
  final List<String> sexOptions = ["male", "female"];

  // Validation Methods
  bool validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      firstnameError.value = "First name cannot be empty";
      return false;
    }
    firstnameError.value = null;
    return true;
  }

  bool validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      lastnameError.value = "Last name cannot be empty";
      return false;
    }
    lastnameError.value = null;
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
      phoneError.value = "Mobile number cannot be empty";
      return false;
    }
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value.trim())) {
      phoneError.value = "Enter a valid mobile number (10-15 digits)";
      return false;
    }
    phoneError.value = null;
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
    final int? weight = int.tryParse(value.trim());
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
    isValid = validateFirstName(firstNameController.text) && isValid;
    isValid = validateLastName(lastNameController.text) && isValid;
    isValid = validateEmail(emailController.text) && isValid;
    isValid = validatePhone(phoneController.text) && isValid;
    isValid = validateAge(ageController.text) && isValid;
    isValid = validateWeight(weightController.text) && isValid;
    isValid = validateSex(selectedSex.value) && isValid;
    return isValid;
  }

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
      final requestData = {
        "first_name": firstNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "mobile_number": phoneController.text.trim(),
        "age": int.parse(ageController.text.trim()),
        "weight": int.parse(weightController.text.trim()),
        "sex": selectedSex.value,
        "email": emailController.text.trim(),
      };

      print("USER Registration: ${jsonEncode(requestData)}");

      final response = await _authRepository.registerUser(requestData);

      print("USER Registration Response: $response");

      if (response != null && response is Map && response['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        String email = response['data']?['email'] ?? emailController.text.trim();
        await prefs.setString('pending_email', email);

        Utils.successSnackBar("Success", response['message'] ?? "Registration successful!");

        Get.toNamed(RouteName.emailView, arguments: {"email": email});
        clearForm();
      } else {
        String errorMessage = response?['message']?.toString() ?? "Registration failed";
        Utils.errorSnackBar("Registration Failed", errorMessage);
      }
    } catch (e) {
      print("USER Registration Error: $e");
      String errorMessage = _handleError(e);
      Utils.errorSnackBar("Error", errorMessage);
    } finally {
      loading.value = false;
    }
  }

  String _handleError(dynamic error) {
    String errorString = error.toString();
    if (errorString.contains('400')) return "Invalid input data";
    if (errorString.contains('409')) return "Email already exists";
    if (errorString.contains('422')) return "Validation failed";
    if (errorString.contains('No Internet')) return "No internet connection";
    if (errorString.contains('timeout')) return "Request timeout";
    return "Something went wrong";
  }

  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    ageController.clear();
    weightController.clear();
    selectedSex.value = '';
    firstnameError.value = null;
    lastnameError.value = null;
    emailError.value = null;
    phoneError.value = null;
    ageError.value = null;
    weightError.value = null;
    sexError.value = null;
    agreeTerms.value = false;
  }
}