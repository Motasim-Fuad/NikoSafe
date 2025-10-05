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

  // Permissions & Venue Types
  final availablePermissions = [
    'displayQRCodes',
    'inAppPromotion',
    'allowRewards',
    'allowEvents',
  ].obs;
  final selectedPermissions = <String>[].obs;

  // Venue Types from API - Store BOTH name and slug
  final availableVenueTypes = <String>[].obs; // Display names for UI
  final venueTypeMap = <String, String>{}.obs; // name -> slug mapping
  final selectedVenueTypes = <String>[].obs; // Selected names
  final isLoadingVenueTypes = false.obs;

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

  @override
  void onInit() {
    super.onInit();
    fetchVenueTypes();
  }

  // Fetch Venue Types from API and build name->slug mapping
  Future<void> fetchVenueTypes() async {
    try {
      isLoadingVenueTypes.value = true;
      final response = await _authRepository.getVenueTypes();

      print("Venue Types Response: $response");

      if (response != null && response is Map && response['success'] == true) {
        final data = response['data'] as List?;
        if (data != null) {
          availableVenueTypes.clear();
          venueTypeMap.clear();

          for (var item in data) {
            String name = item['name'].toString();
            String slug = item['slug'].toString();

            availableVenueTypes.add(name); // For UI display
            venueTypeMap[name] = slug; // Map name to slug for API
          }

          print("Loaded ${availableVenueTypes.length} venue types");
          print("Venue type mapping: $venueTypeMap");
        }
      }
    } catch (e) {
      print("Error loading venue types: $e");
      // Fallback with proper mapping
      availableVenueTypes.value = ['Restaurant', 'Bar', 'Cafe'];
      venueTypeMap.value = {
        'Restaurant': 'restaurant',
        'Bar': 'bar',
        'Cafe': 'cafe',
      };
    } finally {
      isLoadingVenueTypes.value = false;
    }
  }

  // Validation
  bool validateForm() {
    bool isValid = true;

    isValid = _validate(businessNameController.text, businessNameError, "Venue Name cannot be empty") && isValid;
    isValid = _validateEmail(emailController.text) && isValid;
    isValid = _validate(phoneController.text, phoneError, "Phone Number cannot be empty") && isValid;
    isValid = _validate(addressController.text, addressError, "Location cannot be empty") && isValid;
    isValid = _validate(descriptionController.text, descriptionError, "Hours of Operation cannot be empty") && isValid;
    isValid = _validate(capacityController.text, capacityError, "Capacity cannot be empty") && isValid;

    if (selectedVenueTypes.isEmpty) {
      Utils.infoSnackBar("Venue Type Required", "Please select at least one venue type");
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
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked != null) {
        pickedImage.value = File(picked.path);
        Utils.successSnackBar("Success", "Image selected");
      }
    } catch (e) {
      Utils.errorSnackBar("Error", "Failed to pick image");
    }
  }

  Future<void> signup() async {
    if (!validateForm()) return;
    loading.value = true;

    try {
      final requestData = {
        'email': emailController.text.trim(),
        'venue_name': businessNameController.text.trim(),
        'mobile_number': phoneController.text.trim(),
        'location': addressController.text.trim(),
        'hours_of_operation': descriptionController.text.trim(),
        'capacity': capacityController.text.trim(),
      };

      // CRITICAL: Convert display names to slugs for API
      for (int i = 0; i < selectedVenueTypes.length; i++) {
        String selectedName = selectedVenueTypes[i];
        // Get slug from map, fallback to lowercase with dashes if not found
        String slug = venueTypeMap[selectedName] ?? selectedName.toLowerCase().replaceAll(' ', '-');
        requestData['hospitality_venue_type[$i]'] = slug;
      }

      print("VENDOR Registration Data (with slugs): $requestData");

      final response = await _authRepository.registerVendor(
        data: requestData,
        imageFile: pickedImage.value,
      );

      print("Response: $response");

      if (response != null && response is Map && (response['success'] == true || response['statusCode'] == 201)) {
        final prefs = await SharedPreferences.getInstance();

        String? signupToken = response['data']?['signupToken'];
        if (signupToken != null) await prefs.setString('signupToken', signupToken);

        final otp = response['data']?['otp'];
        if (otp != null) await prefs.setString('pendingOtp', otp.toString());

        await prefs.setString('pendingEmail', emailController.text.trim());

        Utils.successSnackBar("Success", response['message'] ?? "Venue registered successfully");

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
    } catch (e) {
      print("Error: $e");
      String errorMessage = _handleRegistrationError(e);
      Utils.errorSnackBar("Error", errorMessage);
    } finally {
      loading.value = false;
    }
  }

  String _extractErrorMessage(Map? response) {
    if (response?['message'] != null) return response!['message'].toString();
    return "Registration failed";
  }

  String _handleRegistrationError(dynamic error) {
    String errorString = error.toString();
    if (errorString.contains('400')) return "Invalid input data";
    if (errorString.contains('409')) return "Email already exists";
    if (errorString.contains('422')) return "Validation failed";
    if (errorString.contains('No Internet')) return "No internet connection";
    if (errorString.contains('timeout')) return "Request timeout";
    return "Something went wrong";
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