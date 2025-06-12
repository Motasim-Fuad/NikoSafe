// lib/view_model/task_request_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nikosafe/utils/utils.dart';

class TaskRequestController extends GetxController {
  final taskTitle = TextEditingController();
  final taskDescription = TextEditingController();
  final estimateTime = TextEditingController();
  final preferredTime = TextEditingController();

  final Rx<File?> pickedImage = Rx<File?>(null);

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      pickedImage.value = File(file.path);
    }
  }

  void submitTask() {
    // You can add your API logic here
 Utils.snackBar("Booking Services", "Data Sent Successfully");
  }

  @override
  void onClose() {
    taskTitle.dispose();
    taskDescription.dispose();
    estimateTime.dispose();
    preferredTime.dispose();
    super.onClose();
  }
}
