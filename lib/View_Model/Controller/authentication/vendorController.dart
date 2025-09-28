import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nikosafe/Repositry/auth_repo/auth_repositry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resource/App_routes/routes_name.dart';
import '../../../utils/utils.dart';

class VendorAuthController extends GetxController {
  final _authRepository = AuthRepository();

  // Form Controllers
  final businessNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();
  final hoursController = TextEditingController();
  final capacityController = TextEditingController();

  // Focus Nodes
  final businessNameFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();
  final addressFocus = FocusNode();
  final descriptionFocus = FocusNode();
  final capacityFocus = FocusNode();

  // Permissions as Multi-Select
  final availablePermissions = [
    'displayQRCodes',
    'inAppPromotion',
    'allowRewards',
    'allowEvents',
  ].obs;
  final selectedPermissions = <String>[].obs;

  // Venue Types as Multi-Select
  final availableVenueTypes = ['Restaurant', 'Bar', 'Night life'].obs;
  final selectedVenueTypes = <String>[].obs;

  // UI State
  final agreeTerms = false.obs;
  final loading = false.obs;
  final pickedImage = Rx<File?>(null);

  // Error Handling
  final businessNameError = Rxn<String>();
  final emailError = Rxn<String>();
  final phoneError = Rxn<String>();
  final passwordError = Rxn<String>();
  final addressError = Rxn<String>();
  final descriptionError = Rxn<String>();
  final hoursError = Rxn<String>();
  final capacityError = Rxn<String>();

  // Validation
  bool validateForm() {
    bool isValid = true;

    isValid = _validate(businessNameController.text, businessNameError, "Venue Name cannot be empty") && isValid;
    isValid = _validateEmail(emailController.text) && isValid;
    isValid = _validate(phoneController.text, phoneError, "Phone Number cannot be empty") && isValid;
    isValid = _validate(passwordController.text, passwordError, "Password cannot be empty") && isValid;
    isValid = _validate(addressController.text, addressError, "Location cannot be empty") && isValid;
    isValid = _validate(descriptionController.text, descriptionError, "Description cannot be empty") && isValid;
    isValid = _validate(capacityController.text, capacityError, "Capacity cannot be empty") && isValid;

    if (selectedVenueTypes.isEmpty) {
      Utils.infoSnackBar("Venue Type Required", "Please select at least one venue type");
      isValid = false;
    }

    if (selectedPermissions.isEmpty) {
      Utils.infoSnackBar("Permissions Required", "Please select at least one permission option");
      isValid = false;
    }

    if (!agreeTerms.value) {
      Utils.infoSnackBar("Terms Required", "Please agree to the Terms & Conditions");
      isValid = false;
    }

    return isValid;
  }

  bool _validate(String? val, Rxn<String> errorField, String errorMsg) {
    if (val == null || val.trim().isEmpty) {
      errorField.value = errorMsg;
      return false;
    }
    errorField.value = null;
    return true;
  }

  bool _validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) {
      emailError.value = "Email cannot be empty";
      return false;
    }
    if (!GetUtils.isEmail(val)) {
      emailError.value = "Enter a valid email";
      return false;
    }
    emailError.value = null;
    return true;
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      pickedImage.value = File(picked.path);
    }
  }
// VendorAuthController.dart - Updated signup method
  Future<void> signup() async {
    if (!validateForm()) return;
    loading.value = true;

    try {
      // ✅ CORRECT STRUCTURE: Build proper field structure for multipart
      final requestData = {
        'email': emailController.text.trim(),
        'password': passwordController.text,

        'profileData': {
          'phone': phoneController.text.trim(),
          'location': addressController.text.trim(),
          'venueName': businessNameController.text.trim(),
          'hoursOfOperation': hoursController.text.trim(),
          'capacity': capacityController.text.trim(),
          'displayQrCodes': selectedPermissions.contains('displayQRCodes').toString(),
          'inAppPromotion': selectedPermissions.contains('inAppPromotion').toString(),
          'allowRewards': selectedPermissions.contains('allowRewards').toString(),
          'allowEvents': selectedPermissions.contains('allowEvents').toString(),
          'firstName': '',
          'lastName': '',
          'resumeUrl': '',
        },
        'profileData[venueTypes]': selectedVenueTypes, // This will be handled as an array
      };

      print("🚀 Vendor Registration Data:");
      print("Email: ${requestData['email']}");
      print("Role: ${requestData['role']}");
      print("ProfileData: ${requestData['profileData']}");
      print("VenueTypes: ${requestData['profileData[venueTypes]']}");
      print("Has Image: ${pickedImage.value != null}");

      final response = await _authRepository.registerUserMultipart(
        data: requestData,
        imageFile: pickedImage.value,
      );

      print("📡 API Response: $response");

      if (response != null && response is Map) {
        bool isSuccess = response['success'] == true || response['statusCode'] == 201;

        if (isSuccess) {
          final prefs = await SharedPreferences.getInstance();

          // Save signup token
          String? signupToken = response['data']?['signupToken'];
          if (signupToken != null && signupToken.isNotEmpty) {
            await prefs.setString('signupToken', signupToken);
          }

          // Save OTP if provided
          final otp = response['data']?['otp'];
          if (otp != null) {
            await prefs.setString('pendingOtp', otp.toString());
          }

          // Save role
          String backendRole = response['data']?['role'] ?? 'HOSPITALITY_VENUE';


          await prefs.setString('pendingEmail', emailController.text.trim());

          Utils.successSnackBar("Success", response['message'] ?? "Venue registered successfully");

          // Navigate to email verification
          Get.toNamed(RouteName.emailView, arguments: {

            "email": emailController.text.trim(),
            "signupToken": signupToken,
            "otp": otp,
          });

          clearForm();
        } else {
          String errorMessage = _extractErrorMessage(response);
          Utils.errorSnackBar("Registration Failed", errorMessage);
        }
      } else {
        Utils.errorSnackBar("Error", "Invalid response from server");
      }
    } catch (e) {
      print("❌ Registration Error: $e");
      String errorMessage = _handleRegistrationError(e);
      Utils.errorSnackBar("Error", errorMessage);
    } finally {
      loading.value = false;
    }
  }

// Add these helper methods to VendorAuthController
  String _extractErrorMessage(Map response) {
    if (response['message'] != null) {
      return response['message'].toString();
    }
    return "Registration failed. Please try again.";
  }

  String _handleRegistrationError(dynamic error) {
    String errorString = error.toString();
    if (errorString.contains('400')) {
      return "Invalid input data. Please check your information.";
    } else if (errorString.contains('409')) {
      return "Email already exists. Please use a different email.";
    } else if (errorString.contains('422')) {
      return "Validation failed. Please check all required fields.";
    } else if (errorString.contains('No Internet')) {
      return "No internet connection. Please check your network.";
    } else if (errorString.contains('timeout')) {
      return "Request timeout. Please try again.";
    }
    return "Something went wrong. Please try again.";
  }

  void clearForm() {
    businessNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    addressController.clear();
    descriptionController.clear();
    hoursController.clear();
    capacityController.clear();
    pickedImage.value = null;
    selectedVenueTypes.clear();
    selectedPermissions.clear();
    agreeTerms.value = false;
  }
}