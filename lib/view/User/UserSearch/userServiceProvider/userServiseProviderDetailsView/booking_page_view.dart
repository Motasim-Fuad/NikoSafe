import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../View_Model/Controller/user/userSearch/userServiceProviderController/booking_controller.dart';

class BookingPageView extends StatelessWidget {
  BookingPageView({super.key});

  final BookingController controller = Get.put(BookingController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Optional: background color
        appBar: AppBar(
          title:  Text("Book a Service",style: TextStyle(color: AppColor.primaryTextColor),),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select Dates:", style: TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 8),
              Obx(() => TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: controller.focusedDay.value,
                selectedDayPredicate: (day) =>
                    controller.selectedDates.any((d) => isSameDay(d, day)),
                onDaySelected: (selectedDay, focusedDay) {
                  controller.toggleDate(selectedDay);
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.lime,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.lime.shade200,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: const TextStyle(color: Colors.white),
                  weekendTextStyle: const TextStyle(color: Colors.white),
                  todayTextStyle: const TextStyle(color: Colors.white),
                  selectedTextStyle: const TextStyle(color: Colors.white),
                  outsideTextStyle: const TextStyle(color: Colors.white60),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white),
                  weekendStyle: TextStyle(color: Colors.white),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(color: Colors.white),
                  leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                  rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                ),
              )),
              const SizedBox(height: 20),
              const Text("Select Time Slots", style: TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 8),
              Obx(() => Column(
                children: controller.timeSlots.map((slot) {
                  return CheckboxListTile(
                    title: Text(slot, style: const TextStyle(color: Colors.white)),
                    value: controller.selectedTimeSlots.contains(slot),
                    onChanged: (_) => controller.toggleTimeSlot(slot),
                  );
                }).toList(),
              )),
              const SizedBox(height: 30),
                RoundButton(width: double.infinity,title: "Book Now", onPress: (){
                  controller.bookNow();
                })
            ],
          ),
        ),
      ),
    );
  }
}

