import 'package:get/get.dart';
import 'package:nikosafe/models/User/myProfileModel/user_history_booking_model.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';

class UserServicesBookingController extends GetxController {
  RxList<UserHistoryBookingModel> bookings = <UserHistoryBookingModel>[
    UserHistoryBookingModel(
      imageUrl: ImageAssets.restaurant4,
      title: 'Luna Lounge',
      subtitle: 'Reservation',
      time: '8:00 PM – 1:00 AM',
      day: 'Mon–Sun',
      amount: 50.99,
      action: BookingAction.cancel,
    ),
    UserHistoryBookingModel(
      imageUrl: ImageAssets.restaurant3,
      title: 'Find Balance & Clarity',
      subtitle: 'Dr. Jane Smith',
      time: '8:00 PM – 1:00 AM',
      day: 'Mon–Sun',
      amount: 50.99,
      action: BookingAction.rebook,
    ),
    UserHistoryBookingModel(
      imageUrl: ImageAssets.restaurant1,
      title: 'Luna Lounge',
      subtitle: 'Reservation',
      time: '8:00 PM – 1:00 AM',
      day: 'Mon–Sun',
      amount: 50.99,
      action: BookingAction.rebookAndReview,
    ),
  ].obs;
}
