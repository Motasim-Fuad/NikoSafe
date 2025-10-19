import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/resource/compunents/coustomTextField.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../View_Model/Controller/user/userSearch/userServiceProviderController/booking_controller.dart';

class BookingPageView extends StatelessWidget {
  BookingPageView({super.key});

  final BookingController controller = Get.put(BookingController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Book a Service", style: TextStyle(color: AppColor.primaryTextColor)),
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
              // ✅ User Input Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C3E50),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.lime.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Service Details",
                      style: TextStyle(
                        color: Colors.lime,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ✅ Hourly Rate Input
                    const Text(
                      "Hourly Rate (\$) *",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: controller.hourlyRateController,
                      keyboardType: TextInputType.number,
                      hintText: "Enter hourly rate",
                      prefixIcon: Icons.attach_money,
                      onChanged: (_) => controller.calculateTotalAmount(),
                    ),

                    const SizedBox(height: 16),

                    // ✅ Estimated Hours Input
                    const Text(
                      "Estimated Hours *",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: controller.estimatedHoursController,
                      keyboardType: TextInputType.number,
                      hintText: "Enter estimated hours",
                      prefixIcon: Icons.access_time,
                      onChanged: (_) => controller.calculateTotalAmount(),
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: Colors.white30),
                    const SizedBox(height: 8),

                    // ✅ Total Amount Display
                    Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Amount:",
                          style: TextStyle(
                            color: Colors.lime,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "\$ ${controller.totalAmount.value.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.lime,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                "Select Your Preferred Date:",
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),

              Obx(() => TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 365)),
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
                  selectedTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
              const Text(
                "Select Your Preferred Time:",
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),

              Obx(() => Column(
                children: controller.timeSlots.map((slot) {
                  final isSelected = controller.selectedTimeSlots.contains(slot);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.lime.withOpacity(0.2) : const Color(0xFF2C3E50),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.lime : Colors.white30,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: CheckboxListTile(
                      title: Text(
                        _formatTime(slot),
                        style: TextStyle(
                          color: isSelected ? Colors.lime : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      value: isSelected,
                      onChanged: (_) => controller.toggleTimeSlot(slot),
                      activeColor: Colors.lime,
                      checkColor: Colors.black,
                    ),
                  );
                }).toList(),
              )),

              const SizedBox(height: 30),
              Obx(() => RoundButton(
                width: double.infinity,
                title: "Confirm Booking",
                onPress: controller.bookNow,
                loading: controller.loading.value,
              )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String time24) {
    final parts = time24.split(':');
    int hour = int.parse(parts[0]);
    String period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;
    return '$hour:${parts[1]} $period';
  }
}