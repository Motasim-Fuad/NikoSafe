import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserEditProfileController extends GetxController {
  var imagePath = "".obs;

  final nameController = TextEditingController(text: "Lukas Wagner");
  final mobileController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final sexController = TextEditingController();
  final emailController = TextEditingController(text: "lukas.wagner@gmail.com");
  final locationController = TextEditingController(text: "Downtown LA");


  void pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imagePath.value = picked.path;
    }
  }

  File getImageFile() => File(imagePath.value);

  void saveProfile() {
    // TODO: Call API or save to local database
    Get.snackbar("Success", "Profile updated successfully", backgroundColor: Colors.green, colorText: Colors.white);
  }
}
