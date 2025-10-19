import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userSearch/UserServiceProviderRepo/booking_repo.dart';
import 'package:nikosafe/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingController extends GetxController {
  final BookingRepository _repo = BookingRepository();

  // ✅ Controllers for user input
  final hourlyRateController = TextEditingController();
  final estimatedHoursController = TextEditingController();

  RxList<DateTime> selectedDates = <DateTime>[].obs;
  RxList<String> selectedTimeSlots = <String>[].obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  RxBool loading = false.obs;
  RxDouble totalAmount = 0.0.obs; // ✅ Observable total amount

  int? providerId;

  final List<String> timeSlots = [
    "09:00:00",
    "10:00:00",
    "11:00:00",
    "13:00:00",
    "14:00:00",
  ];

  @override
  void onInit() {
    super.onInit();

    // ✅ Get only provider ID from navigation
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      providerId = args['providerId'] as int?;
    } else if (args is int) {
      providerId = args;
    }

    print("📋 Booking Controller Initialized with Provider ID: $providerId");

    final today = DateTime.now();
    selectedDates.add(DateTime(today.year, today.month, today.day));

    // ✅ Set default values
    hourlyRateController.text = "100";
    estimatedHoursController.text = "1";
    calculateTotalAmount();
  }

  // ✅ Auto-calculate total amount when user types
  void calculateTotalAmount() {
    final hourlyRate = double.tryParse(hourlyRateController.text.trim()) ?? 0.0;
    final estimatedHours = double.tryParse(estimatedHoursController.text.trim()) ?? 0.0;
    totalAmount.value = hourlyRate * estimatedHours;
  }

  void toggleDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    if (selectedDates.any((d) => isSameDay(d, normalized))) {
      selectedDates.removeWhere((d) => isSameDay(d, normalized));
    } else {
      selectedDates.add(normalized);
    }
    focusedDay.value = normalized;
  }

  void toggleTimeSlot(String slot) {
    if (selectedTimeSlots.contains(slot)) {
      selectedTimeSlots.remove(slot);
    } else {
      selectedTimeSlots.add(slot);
    }
  }

  Future<void> bookNow() async {
    if (providerId == null) {
      Utils.errorSnackBar("Error", "Provider not selected");
      return;
    }

    if (hourlyRateController.text.isEmpty || estimatedHoursController.text.isEmpty) {
      Utils.errorSnackBar("Error", "Please enter hourly rate and estimated hours");
      return;
    }

    if (totalAmount.value <= 0) {
      Utils.errorSnackBar("Error", "Total amount must be greater than 0");
      return;
    }

    if (selectedDates.isEmpty || selectedTimeSlots.isEmpty) {
      Utils.errorSnackBar("Error", "Please select dates and time slots");
      return;
    }

    loading.value = true;

    try {
      print("📤 Booking API Call:");
      print("  Provider ID: $providerId");
      print("  Hourly Rate: ${hourlyRateController.text}");
      print("  Estimated Hours: ${estimatedHoursController.text}");
      print("  Total Amount: $totalAmount");
      print("  Date: ${selectedDates.first.toIso8601String().split('T')[0]}");
      print("  Time: ${selectedTimeSlots.first}");

      final response = await _repo.createBooking(
        providerId: providerId!,
        totalAmount: totalAmount.value.toString(),
        hourlyRate: hourlyRateController.text.trim(), // ✅ Required by backend
        estimatedHours: estimatedHoursController.text.trim(), // ✅ Required by backend
        bookingDate: selectedDates.first.toIso8601String().split('T')[0],
        bookingTime: selectedTimeSlots.first,
      );

      if (response != null && response['success'] == true) {
        Utils.successSnackBar("Success", response['message'] ?? "Booking created successfully");
        Get.back();
      } else {
        Utils.errorSnackBar("Error", response?['message'] ?? "Booking failed");
      }

    } catch (e) {
      print("❌ Booking error: $e");
      Utils.errorSnackBar("Error", "Failed to create booking");
    } finally {
      loading.value = false;
    }
  }

  @override
  void onClose() {
    hourlyRateController.dispose();
    estimatedHoursController.dispose();
    super.onClose();
  }
}