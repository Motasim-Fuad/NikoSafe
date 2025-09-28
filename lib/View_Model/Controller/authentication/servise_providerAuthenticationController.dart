import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nikosafe/Repositry/auth_repo/auth_repositry.dart';
import 'package:nikosafe/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resource/App_routes/routes_name.dart';

class ServiceProviderAuthController extends GetxController {
  final _authRepository = AuthRepository();

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
  final imageError = Rxn<String>();

  // UI State
  final isPasswordVisible = false.obs;
  final agreeTerms = false.obs;
  final loading = false.obs;
  final pickedImage = Rx<File?>(null);
  final rememberMe = false.obs;
  final isImageUploading = false.obs;

  // Options
  final List<String> jobList = ["Plumber", "Electrician", "Cleaner", "Carpenter", "Painter", "Trainer", "Therapist"];

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

  // ✅ Enhanced image validation
  bool validateImage() {
    if (pickedImage.value == null) {
      imageError.value = "Please select a profile image";
      return false;
    }

    // Check file size (limit to 5MB)
    final fileSizeInBytes = pickedImage.value!.lengthSync();
    final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

    if (fileSizeInMB > 5) {
      imageError.value = "Image size should be less than 5MB";
      return false;
    }

    imageError.value = null;
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
    // ✅ Add image validation to form validation
    isValid = validateImage() && isValid;
    return isValid;
  }

  // ✅ Enhanced Image Picker with multiple options
  Future<void> pickImage() async {
    try {
      // Show bottom sheet for image selection options
      final ImageSource? source = await Get.bottomSheet<ImageSource>(
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Image Source',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Get.back(result: ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Get.back(result: ImageSource.camera),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      );

      if (source == null) return;

      isImageUploading.value = true;

      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 1024, // Limit image resolution for better performance
        maxHeight: 1024,
        imageQuality: 85, // Compress image quality
      );

      if (picked != null) {
        final file = File(picked.path);

        // Validate file size
        final fileSizeInBytes = file.lengthSync();
        final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 5) {
          Utils.errorSnackBar("Image Too Large", "Please select an image smaller than 5MB");
          return;
        }

        pickedImage.value = file;
        imageError.value = null; // Clear any previous error
        Utils.successSnackBar("Success", "Image selected successfully");
      } else {
        Utils.infoSnackBar("No Image", "No image selected");
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to pick image: ${e.toString()}");
    } finally {
      isImageUploading.value = false;
    }
  }

  // ✅ Enhanced signup method with better error handling
// ServiceProviderAuthController.dart - Updated signup method
// ServiceProviderAuthController.dart - Update the signup method
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
      // ✅ CORRECT STRUCTURE: Build proper field structure for multipart
      final requestData = {
        'email': emailController.text.trim(),
        'password': passwordController.text,

        'profileData': {
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'phone': phoneController.text.trim(),
          'location': locationController.text.trim(),
          'designation': selectedJob.value,
          'resumeUrl': '',
        },
      };

      print("🚀 Service Provider Registration Data:");
      print("Email: ${requestData['email']}");
      print("Role: ${requestData['role']}");
      print("ProfileData: ${requestData['profileData']}");
      print("Has Image: ${pickedImage.value != null}");

      final response = await _authRepository.registerUserMultipart(
        data: requestData,
        imageFile: pickedImage.value,
      );

      print("📡 API Response: $response");

      if (response != null && response is Map) {
        bool isSuccess = response['success'] == true || response['statusCode'] == 201;

        if (isSuccess) {
          await _handleSuccessfulRegistration(response);
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



  String _extractErrorMessage(Map response) {
    if (response['message'] != null) {
      return response['message'].toString();
    }

    if (response['error'] != null) {
      if (response['error'] is List && response['error'].isNotEmpty) {
        return response['error'][0]['message']?.toString() ?? "Registration failed";
      } else if (response['error'] is String) {
        return response['error'].toString();
      }
    }

    if (response['errors'] != null && response['errors'] is Map) {
      Map errors = response['errors'];
      String errorMsg = "Validation errors: ";
      errors.forEach((key, value) {
        if (value is List && value.isNotEmpty) {
          errorMsg += "$key: ${value[0]}, ";
        }
      });
      return errorMsg.substring(0, errorMsg.length - 2);
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
    } else if (errorString.contains('413')) {
      return "File too large. Please select a smaller image.";
    } else if (errorString.contains('No Internet')) {
      return "No internet connection. Please check your network.";
    } else if (errorString.contains('timeout')) {
      return "Request timeout. Please try again.";
    } else if (errorString.contains('SocketException')) {
      return "Network error. Please check your internet connection.";
    }

    return "Something went wrong. Please try again.";
  }

  // ✅ Helper method to handle different error types
// ✅ Separate method to handle successful registration
  Future<void> _handleSuccessfulRegistration(Map response) async {
    final prefs = await SharedPreferences.getInstance();
    final responseData = response['data'] ?? response;

    // Save signup token
    String? signupToken = responseData['signupToken'] ?? responseData['token'];
    if (signupToken != null && signupToken.isNotEmpty) {
      await prefs.setString('signupToken', signupToken);
      print("💾 Signup token saved");
    }

    // Save OTP if provided
    final otp = responseData['otp'];
    if (otp != null) {
      await prefs.setString('pendingOtp', otp.toString());
      print("💾 OTP saved for verification: $otp");
    }


    await prefs.setString('pendingEmail', emailController.text.trim());

    String successMessage = response['message'] ?? "Service Provider account created successfully";
    Utils.successSnackBar("Success", successMessage);

    // Navigate to email verification
    Get.toNamed(RouteName.emailView, arguments: {

      "email": emailController.text.trim(),
      "signupToken": signupToken,
      "otp": otp,
    });

    clearForm();
  }

  // ✅ Enhanced clear form method
  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    locationController.clear();
    selectedJob.value = '';

    // Clear all error messages
    firstNameError.value = null;
    lastNameError.value = null;
    emailError.value = null;
    phoneError.value = null;
    passwordError.value = null;
    locationError.value = null;
    jobError.value = null;
    imageError.value = null;

    // Reset UI state
    agreeTerms.value = false;
    pickedImage.value = null;
    isPasswordVisible.value = false;

    print("✅ Form cleared successfully");
  }

  // @override
  // void onClose() {
  //   // Dispose controllers to prevent memory leaks
  //   firstNameController.dispose();
  //   lastNameController.dispose();
  //   emailController.dispose();
  //   phoneController.dispose();
  //   passwordController.dispose();
  //   locationController.dispose();
  //
  //   // Dispose focus nodes
  //   firstNameFocus.dispose();
  //   lastNameFocus.dispose();
  //   emailFocus.dispose();
  //   phoneFocus.dispose();
  //   passwordFocus.dispose();
  //   locationFocus.dispose();
  //
  //   super.onClose();
  // }
}