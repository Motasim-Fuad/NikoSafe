import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nikosafe/Repositry/user_repo/userSearch/UserServiceProviderRepo/booking_repo.dart';
import 'package:nikosafe/View_Model/Services/stripe_payment_service.dart';
import 'package:nikosafe/utils/utils.dart';

class TaskRequestController extends GetxController {
  final _repo = BookingRepository();
  final _paymentService = PaymentService();

  final taskTitle = TextEditingController();
  final taskDescription = TextEditingController();
  final estimateTime = TextEditingController();
  final preferredTime = TextEditingController();
  final locationController = TextEditingController();
  final hourlyRateController = TextEditingController();

  final RxList<File> pickedImages = <File>[].obs;
  final RxBool loading = false.obs;
  final RxDouble totalAmount = 0.0.obs;

  int? providerId;

  /// Auto-calculate total amount
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

  /// Submit task with payment
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
      print("📤 Task Request - Creating Booking:");
      print("  Provider ID: $providerId");
      print("  Task Title: ${taskTitle.text}");
      print("  Total Amount: $totalAmount");

      // Step 1: Create booking (using your original repo method)
      final response = await _repo.createBooking(
        providerId: providerId!,
        totalAmount: totalAmount.value.toString(),
        bookingTime: preferredTime.text.isNotEmpty ? preferredTime.text : "09:00:00",
        taskTitle: taskTitle.text.trim(),
        taskDescription: taskDescription.text.trim(),
        location: locationController.text.trim(),
        hourlyRate: hourlyRateController.text.trim(),
        estimatedHours: estimateTime.text.trim(),
        images: pickedImages.isNotEmpty ? pickedImages : null,
      );

      print("📥 Booking Response: $response");

      if (response == null || response['success'] != true) {
        Utils.errorSnackBar("Error", response?['message'] ?? "Booking failed");
        loading.value = false;
        return;
      }

      // Step 2: Get booking ID from response
      final bookingId = response['data']['id'] as int;
      print("✅ Booking created with ID: $bookingId");

      Utils.successSnackBar("Success", "Booking created! Processing payment...");

      // Step 3: Process payment (create intent + present sheet + confirm)
      print("🔄 Starting payment process...");
      final paymentSuccess = await _paymentService.processPayment(
        bookingId: bookingId,
        amount: totalAmount.value,
      );

      loading.value = false;

      if (paymentSuccess) {
        print("✅ Payment successful!");
        Utils.successSnackBar("Success", "Payment successful! Booking confirmed.");
        clearForm();
        Get.back();
      } else {
        print("❌ Payment failed or cancelled");
        Utils.errorSnackBar("Error", "Payment failed or cancelled");
      }

    } catch (e) {
      print("❌ Submit error: $e");
      Utils.errorSnackBar("Error", "Failed to process request: ${e.toString()}");
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