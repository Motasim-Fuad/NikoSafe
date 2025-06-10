import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../Repositry/userSearch/trainer/trainer_booking_repo.dart';
import '../../../../../models/userSearch/trainer/trainer_booking_model.dart';

class TrainerBookingController extends GetxController {
  RxList<DateTime> selectedDates = <DateTime>[].obs;
  RxList<String> selectedTimeSlots = <String>[].obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;

  final List<String> timeSlots = [
    "9:00 AM - 10:00 AM",
    "10:00 AM - 11:00 AM",
    "11:00 AM - 12:00 PM",
    "1:00 PM - 2:00 PM",
    "2:00 PM - 3:00 PM",
  ];

  final TrainerBookingRepository _repo = TrainerBookingRepository();

  @override
  void onInit() {
    super.onInit();
    // Select today only once on first load
    final today = DateTime.now();
    selectedDates.add(DateTime(today.year, today.month, today.day));
  }

  void toggleDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    if (selectedDates.any((d) => isSameDay(d, normalized))) {
      selectedDates.removeWhere((d) => isSameDay(d, normalized));
    } else {
      selectedDates.add(normalized);
    }
    focusedDay.value = normalized; // Important: Refresh calendar display
  }

  void toggleTimeSlot(String slot) {
    if (selectedTimeSlots.contains(slot)) {
      selectedTimeSlots.remove(slot);
    } else {
      selectedTimeSlots.add(slot);
    }
  }

  void bookNow() {
    if (selectedDates.isEmpty || selectedTimeSlots.isEmpty) {
      Get.snackbar("Error", "Please select at least one date and time slot");
      return;
    }

    TrainerBookingModel booking = TrainerBookingModel(
      dates: selectedDates.toList(),
      timeSlots: selectedTimeSlots.toList(),
    );

    _repo.bookTrainer(booking);
    Get.snackbar("Success", "Booking confirmed");
  }
}
