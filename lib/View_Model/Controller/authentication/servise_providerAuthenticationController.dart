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
  final isImageUploading = false.obs;

  // Options - Store BOTH name and slug
  final jobList = <String>[].obs; // Display names for UI
  final jobSlugMap = <String, String>{}.obs; // name -> slug mapping
  final isLoadingDesignations = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDesignations();
  }

  // Fetch Designations from API and build name->slug mapping
  Future<void> fetchDesignations() async {
    try {
      isLoadingDesignations.value = true;
      final response = await _authRepository.getDesignations();

      print("Designations Response: $response");

      if (response != null && response is Map && response['success'] == true) {
        final data = response['data'] as List?;
        if (data != null) {
          jobList.clear();
          jobSlugMap.clear();

          for (var item in data) {
            String name = item['name'].toString();
            String slug = item['slug'].toString();

            jobList.add(name); // For UI display
            jobSlugMap[name] = slug; // Map name to slug for API
          }

          print("Loaded ${jobList.length} designations");
          print("Designation mapping: $jobSlugMap");
        }
      }
    } catch (e) {
      print("Error loading designations: $e");
      // Fallback with proper mapping
      jobList.value = ["Plumber", "Electrician", "Cleaner", "Carpenter", "Painter", "Trainer", "Therapist"];
      jobSlugMap.value = {
        "Plumber": "plumber",
        "Electrician": "electrician",
        "Cleaner": "cleaner",
        "Carpenter": "carpenter",
        "Painter": "painter",
        "Trainer": "trainer",
        "Therapist": "therapist",
      };
    } finally {
      isLoadingDesignations.value = false;
    }
  }

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
      phoneError.value = "Enter a valid mobile number";
      return false;
    }
    phoneError.value = null;
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

  bool validateImage() {
    if (pickedImage.value == null) {
      imageError.value = "Please select a profile image";
      return false;
    }
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
    isValid = validateLocation(locationController.text) && isValid;
    isValid = validateJob(selectedJob.value) && isValid;
    isValid = validateImage() && isValid;
    return isValid;
  }

  Future<void> pickImage() async {
    try {
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
              const Text('Select Image Source', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (picked != null) {
        final file = File(picked.path);
        final fileSizeInMB = file.lengthSync() / (1024 * 1024);
        if (fileSizeInMB > 5) {
          Utils.errorSnackBar("Image Too Large", "Please select an image smaller than 5MB");
          return;
        }
        pickedImage.value = file;
        imageError.value = null;
        Utils.successSnackBar("Success", "Image selected successfully");
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to pick image");
    } finally {
      isImageUploading.value = false;
    }
  }

  Future<void> signup() async {
    if (!agreeTerms.value) {
      Utils.infoSnackBar("Terms Required", "Please agree to the Terms & Conditions");
      return;
    }

    if (!validateForm()) {
      Utils.errorSnackBar("Input Error", "Please correct the errors");
      return;
    }

    loading.value = true;

    try {
      // CRITICAL: Convert display name to slug for API
      String jobSlug = jobSlugMap[selectedJob.value] ?? selectedJob.value.toLowerCase().replaceAll(' ', '-');

      final requestData = {
        'email': emailController.text.trim(),
        'full_name': '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
        'service_provider_designation': jobSlug, // Send slug, not name
        'phone_number': phoneController.text.trim(),
        'location': locationController.text.trim(),
      };

      print("SERVICE PROVIDER Registration Data (with slug): $requestData");

      final response = await _authRepository.registerServiceProvider(
        data: requestData,
        imageFile: pickedImage.value,
      );

      print("Response: $response");

      if (response != null && response is Map && (response['success'] == true || response['statusCode'] == 201)) {
        await _handleSuccessfulRegistration(response);
      } else {
        String errorMessage = _extractErrorMessage(response);
        Utils.errorSnackBar("Registration Failed", errorMessage);
      }
    } catch (e) {
      print("Error: $e");
      String errorMessage = _handleError(e);
      Utils.errorSnackBar("Error", errorMessage);
    } finally {
      loading.value = false;
    }
  }

  Future<void> _handleSuccessfulRegistration(Map response) async {
    final prefs = await SharedPreferences.getInstance();
    final responseData = response['data'] ?? response;

    String? signupToken = responseData['signupToken'] ?? responseData['token'];
    if (signupToken != null) await prefs.setString('signupToken', signupToken);

    final otp = responseData['otp'];
    if (otp != null) await prefs.setString('pendingOtp', otp.toString());

    await prefs.setString('pendingEmail', emailController.text.trim());

    Utils.successSnackBar("Success", response['message'] ?? "Registration successful");

    Get.toNamed(RouteName.emailView, arguments: {
      "email": emailController.text.trim(),
      "signupToken": signupToken,
      "otp": otp,
    });

    clearForm();
  }

  String _extractErrorMessage(Map? response) {
    if (response?['message'] != null) return response!['message'].toString();
    if (response?['error'] != null) {
      if (response!['error'] is List && response['error'].isNotEmpty) {
        return response['error'][0]['message']?.toString() ?? "Registration failed";
      }
      if (response['error'] is String) return response['error'].toString();
    }
    return "Registration failed";
  }

  String _handleError(dynamic error) {
    String errorString = error.toString();
    if (errorString.contains('400')) return "Invalid input data";
    if (errorString.contains('409')) return "Email already exists";
    if (errorString.contains('422')) return "Validation failed";
    if (errorString.contains('413')) return "File too large";
    if (errorString.contains('No Internet')) return "No internet connection";
    if (errorString.contains('timeout')) return "Request timeout";
    return "Something went wrong";
  }

  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    locationController.clear();
    selectedJob.value = '';
    firstNameError.value = null;
    lastNameError.value = null;
    emailError.value = null;
    phoneError.value = null;
    locationError.value = null;
    jobError.value = null;
    imageError.value = null;
    agreeTerms.value = false;
    pickedImage.value = null;
    isPasswordVisible.value = false;
  }
}