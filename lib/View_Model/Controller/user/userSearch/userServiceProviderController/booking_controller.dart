import 'package:get/get.dart';
import 'package:nikosafe/Repositry/user_repo/userSearch/UserServiceProviderRepo/booking_repo.dart';
import 'package:nikosafe/models/User/userSearch/userServiceProviderModel/bookingmodel.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../utils/utils.dart';
import '../../../../../view/User/UserSearch/userServiceProvider/userServiseProviderDetailsView/widgets/taskRequestbottomSheed.dart';

class BookingController extends GetxController {
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

  final BookingRepository _repo = BookingRepository();

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

    BookingModel booking = BookingModel(
      dates: selectedDates.toList(),
      timeSlots: selectedTimeSlots.toList(),
    );

    _repo.book(booking);

    Utils.successSnackBar("Booking", "Booking Request Successfully",
    );
  }
}
