import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nikosafe/Repositry/user_repo/userSearch/UserServiceProviderRepo/booking_repo.dart';
import 'package:nikosafe/utils/utils.dart';

class TaskRequestController extends GetxController {
  final _repo = BookingRepository();

  final taskTitle = TextEditingController();
  final taskDescription = TextEditingController();
  final estimateTime = TextEditingController();
  final preferredTime = TextEditingController();
  final locationController = TextEditingController();
  final hourlyRateController = TextEditingController();

  final RxList<File> pickedImages = <File>[].obs;
  final RxBool loading = false.obs;
  final RxDouble totalAmount = 0.0.obs; // ✅ Observable total amount

  int? providerId;

  // ✅ Auto-calculate total amount
  void calculateTotalAmount() {
    final hourlyRate = double.tryParse(hourlyRateController.text.trim()) ?? 0.0;
    final estimatedHours = double.tryParse(estimateTime.text.trim()) ?? 0.0;
    totalAmount.value = hourlyRate * estimatedHours;
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.lime,
              onPrimary: Colors.black,
              surface: Color(0xFF2C3E50),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00";
      preferredTime.text = formattedTime;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final List<XFile> files = await picker.pickMultiImage();

    if (files.isNotEmpty) {
      pickedImages.addAll(files.map((file) => File(file.path)));
    }
  }

  void removeImage(int index) {
    pickedImages.removeAt(index);
  }

  Future<void> submitTask() async {
    if (providerId == null) {
      Utils.errorSnackBar("Error", "Provider not selected");
      return;
    }

    if (taskTitle.text.isEmpty || taskDescription.text.isEmpty) {
      Utils.errorSnackBar("Error", "Please fill all required fields");
      return;
    }

    if (hourlyRateController.text.isEmpty || estimateTime.text.isEmpty) {
      Utils.errorSnackBar("Error", "Please enter hourly rate and estimated hours");
      return;
    }

    if (totalAmount.value <= 0) {
      Utils.errorSnackBar("Error", "Total amount must be greater than 0");
      return;
    }

    loading.value = true;

    try {
      final response = await _repo.createBooking(
        providerId: providerId!,
        totalAmount: totalAmount.value.toString(), // ✅ Pass calculated total
        bookingTime: preferredTime.text.isNotEmpty ? preferredTime.text : "09:00:00",
        taskTitle: taskTitle.text.trim(),
        taskDescription: taskDescription.text.trim(),
        location: locationController.text.trim(),
        hourlyRate: hourlyRateController.text.trim(),
        estimatedHours: estimateTime.text.trim(),
        images: pickedImages.isNotEmpty ? pickedImages : null,
      );

      print("📥 Response: $response");

      if (response != null && response['success'] == true) {
        Utils.successSnackBar("Success", response['message'] ?? "Task request sent successfully");
        clearForm();
        Get.back();
      } else {
        Utils.errorSnackBar("Error", response?['message'] ?? "Request failed");
      }

    } catch (e) {
      print("❌ Submit error: $e");
      Utils.errorSnackBar("Error", "Failed to send request");
    } finally {
      loading.value = false;
    }
  }

  void clearForm() {
    taskTitle.clear();
    taskDescription.clear();
    estimateTime.clear();
    preferredTime.clear();
    locationController.clear();
    hourlyRateController.clear();
    pickedImages.clear();
    totalAmount.value = 0.0;
  }

  @override
  void onClose() {
    taskTitle.dispose();
    taskDescription.dispose();
    estimateTime.dispose();
    preferredTime.dispose();
    locationController.dispose();
    hourlyRateController.dispose();
    super.onClose();
  }
}