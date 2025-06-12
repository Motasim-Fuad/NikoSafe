import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/models/userSearch/theraphy_session/theraphy_booking_model.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../Repositry/userSearch/TheraphySessions/theraphy_booking_repo.dart';


class TheraphySessionBookingController extends GetxController {
  Rx<DateTime> focusedDay = DateTime.now().obs;
  RxList<DateTime> selectedDates = <DateTime>[].obs;
  RxList<String> selectedTimeSlots = <String>[].obs;

  final List<String> timeSlots = [
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '2:00 PM',
    '4:00 PM',
  ];

  void toggleDate(DateTime date) {
    if (selectedDates.any((d) => isSameDay(d, date))) {
      selectedDates.removeWhere((d) => isSameDay(d, date));
    } else {
      selectedDates.add(date);
    }
    focusedDay.value = date;
  }

  void toggleTimeSlot(String slot) {
    if (selectedTimeSlots.contains(slot)) {
      selectedTimeSlots.remove(slot);
    } else {
      selectedTimeSlots.add(slot);
    }
  }

  void bookNow() async {
    if (selectedDates.isEmpty || selectedTimeSlots.isEmpty) {
      Get.snackbar("Missing Info", "Please select at least one date and one time slot",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final booking = TheraphyBookingModel(
      dates: selectedDates,
      timeSlots: selectedTimeSlots,
    );

    try {
      await TheraphyBookingRepo().bookTrainer(booking);
      Get.snackbar("Success", "Booking confirmed!",
          backgroundColor: Colors.green, colorText: Colors.white);
      selectedDates.clear();
      selectedTimeSlots.clear();
    } catch (e) {
      Get.snackbar("Error", "Failed to book session",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
