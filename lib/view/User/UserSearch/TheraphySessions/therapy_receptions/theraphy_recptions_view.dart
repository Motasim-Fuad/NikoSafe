import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../View_Model/Controller/user/userSearch/TheraphySessions/theraphy_session_booking_controller.dart';


class TheraphyRecptionsView extends StatelessWidget {
  TheraphyRecptionsView({super.key});

  final TheraphySessionBookingController controller = Get.put(TheraphySessionBookingController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Dates:", style: TextStyle(fontSize: 16,color: Colors.white)),
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
            defaultTextStyle: const TextStyle(color: Colors.white), // <- normal days
            weekendTextStyle: const TextStyle(color: Colors.white), // <- weekends
            todayTextStyle: const TextStyle(color: Colors.white),   // <- today
            selectedTextStyle: const TextStyle(color: Colors.white), // <- selected
            outsideTextStyle: const TextStyle(color: Colors.white60), // <- outside month
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: Colors.white), // <- Mon–Fri labels
            weekendStyle: TextStyle(color: Colors.white), // <- Sat–Sun labels
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(color: Colors.white), // <- Month + Year
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
          ),
        )),


        const SizedBox(height: 20),
        const Text("Select Time Slots", style: TextStyle(fontSize: 18,color: Colors.white)),
        const SizedBox(height: 8),
        Obx(() => Column(
          children: controller.timeSlots.map((slot) {
            return CheckboxListTile(
              title: Text(slot,style: TextStyle(color: Colors.white),),
              value: controller.selectedTimeSlots.contains(slot),
              onChanged: (_) => controller.toggleTimeSlot(slot),
            );
          }).toList(),
        )),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: controller.bookNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text("Book Now",style: TextStyle(color: Colors.white),),
          ),
        )
      ],
    );
  }
}
