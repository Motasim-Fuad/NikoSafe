
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nikosafe/view/User/UserProfile/Screen/user_history/user_services_venue_bookingView/widgets/booking_card_widgets.dart';
import '../../../../../../View_Model/Controller/user/MyProfile/user_services_booking_controller/user_services_booking_controller.dart';
class UserServicesAndvanuebokkingview extends StatelessWidget {
  final controller = Get.put(UserServicesBookingController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12),
      itemCount: controller.bookings.length,
      itemBuilder: (context, index) {
        final booking = controller.bookings[index];
        return UserHistoryBookingCard(booking: booking);
      },
    ));
  }
}
