import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resource/App_routes/routes_name.dart';
import '../../../utils/utils.dart';

class VendorAuthController extends GetxController {
  // Form Controllers
  final businessNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();
  final hoursController = TextEditingController();
  final capacityController = TextEditingController();

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

  Future<void> signup() async {
    if (!validateForm()) return;

    loading.value = true;
    try {
      final vendorData = {
        'businessName': businessNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text.trim(),
        'address': addressController.text.trim(),
        'description': descriptionController.text.trim(),
        'hoursOfOperation': hoursController.text.trim(),
        'capacity': int.tryParse(capacityController.text.trim()) ?? 0,
        'displayQRCodes': selectedPermissions.contains('displayQRCodes'),
        'inAppPromotion': selectedPermissions.contains('inAppPromotion'),
        'allowRewards': selectedPermissions.contains('allowRewards'),
        'allowEvents': selectedPermissions.contains('allowEvents'),
        'venueTypes': selectedVenueTypes.toList(),
        'role': 'vendor',
      };

      await Future.delayed(const Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', 'vendor_token');
      await prefs.setString('role', 'vendor');

      Utils.successSnackBar("Success", "Vendor signed up successfully");
      Get.toNamed(RouteName.emailView, arguments: {
        "role": "vendor",
        "email": emailController.text.trim()
      });

      clearForm();
    } catch (e) {
      Utils.errorSnackBar("Error", e.toString());
    } finally {
      loading.value = false;
    }
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

  // @override
  // void onClose() {
  //   businessNameController.dispose();
  //   emailController.dispose();
  //   phoneController.dispose();
  //   passwordController.dispose();
  //   addressController.dispose();
  //   descriptionController.dispose();
  //   hoursController.dispose();
  //   capacityController.dispose();
  //   super.onClose();
  // }
}
