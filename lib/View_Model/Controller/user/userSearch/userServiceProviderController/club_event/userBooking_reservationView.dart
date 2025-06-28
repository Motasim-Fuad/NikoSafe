import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nikosafe/utils/utils.dart';

class ClubUserBookingReservationController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameText = TextEditingController();
  final emailText = TextEditingController();
  final phoneText = TextEditingController();
  final guestsText = TextEditingController();
  final dateText = TextEditingController();

  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();
  final guestsFocus = FocusNode();
  final dateFocus = FocusNode();

  RxInt selectedSlotIndex = (-1).obs;

  List<String> timeSlots = [
    "10:40 AM – 11:00 AM",
    "11:00 AM – 11:20 AM",
    "11:20 AM – 11:40 AM",
    "11:40 AM – 12:00 PM",
  ];

  void pickDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      dateText.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void submitReservation() {
    if (!formKey.currentState!.validate()) return;

    if (selectedSlotIndex.value == -1) {
      Utils.errorSnackBar("Validation", "Please select a time slot");
      return;
    }

    final selectedTime = timeSlots[selectedSlotIndex.value];
    Utils.successSnackBar("Reservation Confirmed", "Time: $selectedTime");

    // Reset
    nameText.clear();
    emailText.clear();
    phoneText.clear();
    guestsText.clear();
    dateText.clear();
    selectedSlotIndex.value = -1;
  }

  @override
  void onClose() {
    nameText.dispose();
    emailText.dispose();
    phoneText.dispose();
    guestsText.dispose();
    dateText.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    guestsFocus.dispose();
    dateFocus.dispose();
    super.onClose();
  }
}
