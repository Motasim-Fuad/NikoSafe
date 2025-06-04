import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart%20';
import 'package:image_picker/image_picker.dart';
import 'package:nikosafe/resource/App_routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Repositry/auth_repo/auth_repositry.dart';

class AuthViewModel extends GetxController {
  final isLogin = true.obs;
  final isUser = true.obs;
  final loading = false.obs;

  // Form controllers
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final sexController = TextEditingController();
  final birthController = TextEditingController();
  final locationController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();


  RxBool isPasswordVisible = false.obs;

  final RxString selectedJob = ''.obs;
  final List<String> jobList = ["Plumber", "Electrician", "Cleaner"];
  final agreeTerms = true.obs;

  late final String role;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    if (args != null && args is Map && args.containsKey('role')) {
      role = args['role'];
    } else {
      role = 'user'; // fallback
      debugPrint("⚠️ Warning: 'role' argument not passed to AuthViewModel.");
    }

    isUser.value = role == 'user';
    debugPrint("✅ Role set to: $role");
  }



  // Future<void> login() async {
  //   loading.value = true;
  //
  //   final data = {
  //     'email': emailController.text.trim(),
  //     'password': passwordController.text,
  //   };
  //
  //   try {
  //     final res = await AuthRepository().login(data);
  //     loading.value = false;
  //
  //     if (res['token'] != null) {
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('token', res['token']);
  //       await prefs.setString('role', role); // Store actual role
  //
  //       Get.snackbar("Success", "Logged in successfully");
  //
  //       // Navigate based on role
  //       if (role == 'user') {
  //         Get.offNamed(RouteName.userHomeView);
  //       } else if (role == 'sub_admin') {
  //         Get.offNamed(RouteName.prviderHomeView);
  //       } else {
  //         Get.snackbar("Error", "Unknown role");
  //       }
  //     } else {
  //       Get.snackbar("Error", res['message'] ?? "Login failed");
  //     }
  //   } catch (e) {
  //     loading.value = false;
  //     Get.snackbar("Error", "Something went wrong: $e");
  //   }
  // }


  Future<void> login() async {

    if (role == 'user') {
            Get.toNamed(RouteName.userBottomNavView);
          } else if (role == 'sub_admin') {
            Get.toNamed(RouteName.providerBtmNavView);
          }
  // //
  // //   // loading.value = true;
  // //
  // //   // final data = {
  // //   //   'email': emailController.text.trim(),
  // //   //   'password': passwordController.text,
  // //   // };
  // //   //
  // //   // try {
  // //   //   final res = await AuthRepository().login(data);
  // //   //   loading.value = false;
  // //   //
  // //   //   if (res['token'] != null) {
  // //   //     final prefs = await SharedPreferences.getInstance();
  // //   //     await prefs.setString('role', isUser.value ? 'user' : 'sub_admin');
  // //   //     Get.snackbar("Success", "Logged in successfully");
  // //   //
  // //   //     // ✅ Navigate based on role
  // //   //     if (role == 'user') {
  // //   //       Get.toNamed(RouteName.userHomeView);
  // //   //     } else if (role == 'sub_admin') {
  // //   //       Get.toNamed(RouteName.prviderHomeView);
  // //   //     }
  // //   //
  // //   //   } else {
  // //   //     Get.snackbar("Error", res['message'] ?? "Login failed");
  // //   //
  // //   //
  // //   //     // ✅ Navigate based on role
  // //   //     final prefs = await SharedPreferences.getInstance();
  // //   //     await prefs.setString('role', isUser.value ? 'user' : 'sub_admin');
  // //   //     if (role == 'user') {
  // //   //       Get.toNamed(RouteName.userHomeView);
  // //   //     } else if (role == 'sub_admin') {
  // //   //       Get.toNamed(RouteName.prviderHomeView);
  // //   //     }
  // //
  // //
  // //   //   }
  // //   // } catch (e) {
  // //   //   loading.value = false;
  // //   //   Get.snackbar("Error", "Something went wrong");
  // //   //
  // //   //
  // //   //
  // //   //   // ✅ Navigate based on role
  // //   //   final prefs = await SharedPreferences.getInstance();
  // //   //   await prefs.setString('role', isUser.value ? 'user' : 'sub_admin');
  // //   //   if (role == 'user') {
  // //   //     Get.toNamed(RouteName.userHomeView);
  // //   //   } else if (role == 'sub_admin') {
  // //   //     Get.toNamed(RouteName.prviderHomeView);
  // //   //   }
  // //   //
  // //   //
  // //   // }
  }


  Future<void> signup() async {
    if (!agreeTerms.value) {
      Get.snackbar("Terms Required", "Please agree to the Terms & Conditions");
      return;
    }

    loading.value = true;

    final Map<String, String> data = {
      'email': emailController.text.trim(),
      'name': nameController.text.trim(),
      'phoneNumber': phoneController.text.trim(),
      'password': passwordController.text,
      'role': isUser.value ? 'user' : 'sub_admin',
    };

    if (!isUser.value) {
      data.addAll({
        'job': selectedJob.value,
        'birthDate': birthController.text,
        'location': locationController.text,
      });
    }

    try {
      final res = await AuthRepository().signupWithImage(
        data: data,
        imageFile: pickedImage.value,
      );

      loading.value = false;

      if (res['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        final token = res['data']['otpToken']['token'];
        await prefs.setString('token', token);
        await prefs.setString('role', isUser.value ? 'user' : 'sub_admin');
        Get.snackbar("Success", "Signed up successfully");


        final resolvedRole = isUser.value ? 'user' : 'sub_admin';
        Get.toNamed(RouteName.emailView, arguments: {"role": resolvedRole});
        print(resolvedRole);
        print(resolvedRole);




        clearFormFields();
      } else {
        Get.snackbar("Error", res['message'] ?? "Signup failed");
      }

    } catch (e) {
      loading.value = false;
      Get.snackbar("Error", "Something went wrong");
    }
  }

  void clearFormFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    birthController.clear();
    locationController.clear();
    ageController.clear();
    weightController.clear();
    sexController.clear();

    selectedJob.value = '';
    agreeTerms.value = false;
    pickedImage.value = null;
  }





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



  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    clearFormFields();
    pickedImage.value = null;

    Get.offAllNamed(RouteName.authView);
    Get.snackbar("Logged out", "You have been successfully logged out");
  }


}
